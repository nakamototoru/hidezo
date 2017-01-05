//
//  HDZItemOrderDialogViewController.swift
//  buyer
//
//  Created by デザミ on 2016/08/19.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import Unbox

class HDZItemOrderDialogViewController: UIViewController {

	var supplierId: String = ""

	@IBOutlet weak var pickerviewDate: UIPickerView!
	@IBOutlet weak var pickerviewCharge: UIPickerView!
	@IBOutlet weak var pickerviewPlace: UIPickerView!
	@IBOutlet weak var textviewComment: UIPlaceHolderTextView!
	@IBOutlet weak var barbuttonitemOrder: UIBarButtonItem!

	private var arrayDate:[String] = [] //NSMutableArray!
	private var arrayCharge:NSMutableArray!
	private var arrayPlace:NSMutableArray!
	
	private var itemResult: ItemResult! = nil
	private var request: Alamofire.Request? = nil
	private var orderResult: Results<HDZOrder>? = nil
	private var indicatorView:CustomIndicatorView!

	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//		self.arrayDate = NSMutableArray()
//		self.arrayDate.addObjectsFromArray(HDZItemOrderManager.shared.getListDate())
		self.arrayCharge = NSMutableArray()
		self.arrayPlace = NSMutableArray()
		
		self.textviewComment.text = HDZItemOrderManager.shared.comment
		self.textviewComment.layer.cornerRadius = 5.0
		self.textviewComment.layer.borderWidth = 1.0
		self.textviewComment.layer.borderColor = UIColor.grayColor().CGColor
		self.textviewComment.placeHolder = "コメント"

		// キーボード閉じる
		// 仮のサイズでツールバー生成
		let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
		kbToolBar.barStyle = UIBarStyle.Default  // スタイルを設定
		kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
		// スペーサー
		let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
		// 閉じるボタン
		let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: #selector(HDZItemOrderDialogViewController.commitButtonTapped))
		kbToolBar.items = [spacer, commitButton]
		self.textviewComment.inputAccessoryView = kbToolBar
		
		//インジケーター
		self.indicatorView = CustomIndicatorView.createView(self.view.frame.size)
		self.view.addSubview(self.indicatorView)

		// APi
		self.getItem(self.supplierId)
    }

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		self.request?.resume()
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		
		self.request?.suspend()
	}
	
	func commitButtonTapped (){
		self.view.endEditing(true)
	}
	
	func updateButtonEnabled(enabled:Bool) {
		barbuttonitemOrder.enabled = enabled
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
}

// MARK: - Create
extension HDZItemOrderDialogViewController {
	
	internal class func createViewController(supplierId: String) -> HDZItemOrderDialogViewController {
		let controller: HDZItemOrderDialogViewController = UIViewController.createViewController("HDZItemOrderDialogViewController")
		controller.supplierId = supplierId
		return controller
	}

}

// MARK: - API
extension HDZItemOrderDialogViewController {
	
	private func getItem(supplierId: String) {
		
		let completion: (unboxable: ItemResult?) -> Void = { (unboxable) in
			
			self.request = nil
			
			guard let result: ItemResult = unboxable else {
				return
			}
			
			self.itemResult = result
			
			#if DEBUG
			let supid:String = String(self.itemResult.supplier.supplier_id)
			let supname:String = self.itemResult.supplier.supplier_name
			debugPrint(supid + ":" + supname)
			#endif
			
			// Picekr init
			// 納品日一覧
//			let deliverDays:[String] = self.itemResult.delivery_day_list
//			self.arrayDate.removeAll()
			self.arrayDate = self.itemResult.delivery_day_list
			
			// 担当者一覧
			let charges:NSArray = self.itemResult.charge_list
			self.arrayCharge.removeAllObjects()
			self.arrayCharge.addObjectsFromArray(charges as! [String])
			// オフセット値
			if HDZItemOrderManager.shared.charge == "" {
				HDZItemOrderManager.shared.charge = self.arrayCharge[0] as! String
			}

			// 配達先一覧（任意）
			let places:NSArray = self.itemResult.deliver_to_list
			self.arrayPlace.removeAllObjects()
			self.arrayPlace.addObject("選択なし")
			self.arrayPlace.addObjectsFromArray(places as! [String])
			
			// ピッカー更新
			self.pickerviewCharge.reloadAllComponents()
			self.pickerviewPlace.reloadAllComponents()
			self.pickerviewDate.reloadAllComponents()
			
			//ピッカー位置
			var count:Int = 0
			var pickerposition:Int = 0
			for str in self.arrayDate {
				if HDZItemOrderManager.shared.deliverdate == str {
					pickerposition = count
					break;
				}
				count += 1
			}
			self.pickerviewDate.selectRow(pickerposition, inComponent: 0, animated: false)
			
			count = 0
			pickerposition = 0
			for str in self.arrayCharge {
				if HDZItemOrderManager.shared.charge == str as! String {
					pickerposition = count
					break;
				}
				count += 1
			}
			self.pickerviewCharge.selectRow(pickerposition, inComponent: 0, animated: false)
			
			count = 0
			pickerposition = 0
			for str in self.arrayPlace {
				if HDZItemOrderManager.shared.deliverto == str as! String {
					pickerposition = count
					break;
				}
				count += 1
			}
			self.pickerviewPlace.selectRow(pickerposition, inComponent: 0, animated: false)
			// end
		}
		
		// API
		let error: (error: ErrorType?, unboxable: ItemError?) -> Void = { (error, unboxable) in

			self.request = nil
		}
		self.request = HDZApi.item(supplierId, completionBlock: completion, errorBlock: error)
	}
}

// MARK: - Order
extension HDZItemOrderDialogViewController {

	// 注文実行
	internal func didSelectedOrder() {
		self.orderResult = try! HDZOrder.queries(self.supplierId)
		
		guard let items: Results<HDZOrder> = self.orderResult else {
			
			// アイテム無し
			let action: UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
			let controller: UIAlertController = UIAlertController(title: "アイテム無し", message: nil, preferredStyle: .Alert)
			controller.addAction(action)
			self.presentViewController(controller, animated: true, completion: nil)
			
			return
		}
		
		//インジケータ
		self.indicatorView.startAnimating()
		
		let completion: (unboxable: OrderResult?) -> Void = { (unboxable) in
			
			// 注文確定
			self.indicatorView.stopAnimating()
			
			//履歴を全て消す
			for object in self.orderResult! {
				try! HDZOrder.deleteObject(object)
			}
			
			let action: UIAlertAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
				
				// タブ画面に戻る＝モーダルを閉じる
				self.navigationController?.viewControllers[1].dismissViewControllerAnimated(true) {
					// 注文履歴タブへ遷移
					// 1.ルートビュー取得
					if let rootvc:UIViewController = (UIApplication.sharedApplication().keyWindow?.rootViewController)! {
						//debugPrint(rootvc.title)
						// 2.タブバーコントローラーチェック
						if rootvc.title == "HDZHomeViewController" {
							// 3.タブバータイテム選択
							let tabbarctrl:UITabBarController = rootvc as! UITabBarController
							tabbarctrl.selectedIndex = 1
						}						
					}
				}
			}
			let controller: UIAlertController = UIAlertController(title: "注文確定", message: nil, preferredStyle: .Alert)
			controller.addAction(action)
			let basevc:UIViewController = MyWarning.getBaseViewController()
			basevc.presentViewController(controller, animated: false) {
			}
			
			
			// メッセージ送信チェック
			guard let result: OrderResult = unboxable else {
				HDZItemOrderManager.shared.clearAllData()
				return
			}
			if HDZItemOrderManager.shared.comment == "" {
				HDZItemOrderManager.shared.clearAllData()
				return
			}
			
			// APIメッセージ送信
			let completion: (unboxable: MessageAddResult?) -> Void = { (unboxable) in
				HDZItemOrderManager.shared.clearAllData()
			}
			let error: (error: ErrorType?, unboxable: MessageAddError?) -> Void = { (error, unboxable) in
				#if DEBUG
					debugPrint(error)
				#endif
				HDZItemOrderManager.shared.clearAllData()
			}
			self.request = HDZApi.adMessage(result.order_no, charge: HDZItemOrderManager.shared.charge, message: HDZItemOrderManager.shared.comment, completionBlock: completion, errorBlock: error)
			
		}
		
		let error: (error: ErrorType?, unboxable: OrderError?) -> Void = { (error, unboxable) in
			
			// 注文エラー
			self.indicatorView.stopAnimating()
			
			let action: UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
			let controller: UIAlertController = UIAlertController(title: "注文エラー", message: error.debugDescription, preferredStyle: .Alert)
			controller.addAction(action)
			self.presentViewController(controller, animated: true, completion: nil)
			
			// ボタン有効
			//			self.barbuttonitemConfirm.enabled = true;
			self.updateButtonEnabled(true)
		}
		
		// Request
		HDZApi.order(self.supplierId, deliver_to: HDZItemOrderManager.shared.deliverto, delivery_day: HDZItemOrderManager.shared.deliverdate, charge: HDZItemOrderManager.shared.charge, items: items, completionBlock: completion, errorBlock: error)
		
	}

}

// MARK: - Action
extension HDZItemOrderDialogViewController {
	
	@IBAction func onCloseDialog(sender: AnyObject) {
		
	}
	
	@IBAction func onSaveDialog(sender: AnyObject) {
		
	}
	
	@IBAction func onSendOrder(sender: AnyObject) {
		
		// TODO:注文実行
		// 配送情報
		// 担当者
		if HDZItemOrderManager.shared.charge == "" {
			// 担当者一覧
			let charges:[String] = self.itemResult.charge_list
			HDZItemOrderManager.shared.charge = charges[0]
		}
		// 配送日
		if HDZItemOrderManager.shared.deliverdate == "" {
			// 配送日一覧
			let dates:[String] = HDZItemOrderManager.shared.getListDate()
			HDZItemOrderManager.shared.deliverdate = dates[0]
		}
		// 配送先は空白ありなのでそのまま
		//		let place:String = HDZItemOrderManager.shared.deliverto
		
		// ボタン無効
		self.updateButtonEnabled(false)
		
		// 「注文しますか？」
		let cancelaction:UIAlertAction = UIAlertAction(title: "いいえ", style: .Cancel) { (action:UIAlertAction!) in
			// キャンセル
			// ボタン有効
			self.updateButtonEnabled(true)
		}
		let confirmaction:UIAlertAction = UIAlertAction(title: "はい", style: .Default) { (action:UIAlertAction!) in
			// 確定
			self.didSelectedOrder()
		}
		let alert:UIAlertController = UIAlertController(title:"注文",
		                                                message: "確定しますか？",
		                                                preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(cancelaction)
		alert.addAction(confirmaction)
		self.presentViewController(alert, animated: false, completion: nil)
	}
	
}

// MARK: - UITextViewDelegate
extension HDZItemOrderDialogViewController: UITextViewDelegate {
	
	func textViewDidChange(textView: UITextView) {
		
		self.textviewComment.textChanged(nil)
	}
	
	func textViewDidEndEditing(textView: UITextView) {
		HDZItemOrderManager.shared.comment = self.textviewComment.text
	}

}

// MARK: - UIPickerViewDataSource
extension HDZItemOrderDialogViewController: UIPickerViewDataSource {
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		
		if pickerView == self.pickerviewDate {
			return self.arrayDate.count
		}
		if pickerView == self.pickerviewCharge {
			return self.arrayCharge.count
		}
		if pickerView == self.pickerviewPlace {
			return self.arrayPlace.count
		}
		
		return 1 //self.chargeList.count
	}
}

// MARK: - UIPickerViewDelegate
extension HDZItemOrderDialogViewController: UIPickerViewDelegate {
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		
		if pickerView == self.pickerviewDate {
			// 必須
			HDZItemOrderManager.shared.deliverdate = self.arrayDate[row] 
		}
		else if pickerView == self.pickerviewCharge {
			// 必須
			HDZItemOrderManager.shared.charge = self.arrayCharge[row] as! String
		}
		else if pickerView == self.pickerviewPlace {
			if row >= 1 {
				// 任意
				HDZItemOrderManager.shared.deliverto = self.arrayPlace[row] as! String
			}
			else {
				// 空白
				HDZItemOrderManager.shared.deliverto = ""
			}
		}
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
		if pickerView == self.pickerviewDate {
			return self.arrayDate[row]
		}
		if pickerView == self.pickerviewCharge {
			return self.arrayCharge[row] as? String
		}
		if pickerView == self.pickerviewPlace {
			return self.arrayPlace[row] as? String
		}

		return "aaa" //self.chargeList[row]
	}
	
}
