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

	var arrayDate:[String] = []
	var arrayCharge: [String] = [] //:NSMutableArray!
	var arrayPlace: [String] = [] //NSMutableArray!
	
	var itemResult: ItemResult! = nil
	var request: Alamofire.Request? = nil
	var orderResult: Results<HDZOrder>? = nil
	var indicatorView:CustomIndicatorView!

	var order_no = ""
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//		self.arrayCharge = NSMutableArray()
//		self.arrayPlace = NSMutableArray()
		
		self.textviewComment.text = HDZItemOrderManager.shared.comment
		self.textviewComment.layer.cornerRadius = 5.0
		self.textviewComment.layer.borderWidth = 1.0
		self.textviewComment.layer.borderColor = UIColor.gray.cgColor
		self.textviewComment.placeHolder = "コメント"

		// キーボード閉じる
		// 仮のサイズでツールバー生成
		let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
		kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
		kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
		// スペーサー
		let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
		// 閉じるボタン
		let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(HDZItemOrderDialogViewController.commitButtonTapped))
		kbToolBar.items = [spacer, commitButton]
		self.textviewComment.inputAccessoryView = kbToolBar
		
		//インジケーター
		self.indicatorView = CustomIndicatorView.createView(framesize: self.view.frame.size)
		self.view.addSubview(self.indicatorView)

		// APi
		self.getItem(supplierId: self.supplierId)
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		self.request?.resume()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		self.request?.suspend()
	}
	
	func commitButtonTapped (){
		self.view.endEditing(true)
	}
	
	func updateButtonEnabled(enabled:Bool) {
		barbuttonitemOrder.isEnabled = enabled
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
}

// MARK: - Create
extension HDZItemOrderDialogViewController {
	
	internal class func createViewController(supplierId: String) -> HDZItemOrderDialogViewController {
		let controller: HDZItemOrderDialogViewController = UIViewController.createViewController(name: "HDZItemOrderDialogViewController")
		controller.supplierId = supplierId
		return controller
	}

}

// MARK: - API
extension HDZItemOrderDialogViewController {
	
	func getItem(supplierId: String) {
		
		let completion: (_ unboxable: ItemResult?) -> Void = { (unboxable) in
			
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
			// 1.納品日一覧
			self.arrayDate = self.itemResult.delivery_day_list
			
			// 2.担当者一覧
			let charges = self.itemResult.charge_list
			self.arrayCharge.removeAll()
			//self.arrayCharge.addObjectsFromArray(charges as! [String])
			self.arrayCharge.append(contentsOf: charges) //  .addObjects(from: charges)
			// オフセット値
			if HDZItemOrderManager.shared.charge == "" {
				let charge = self.arrayCharge[0]
				HDZItemOrderManager.shared.charge = charge //self.arrayCharge[0] as! String
			}

			// 3.配達先一覧（任意）
			let places = self.itemResult.deliver_to_list
			self.arrayPlace.removeAll() //.removeAllObjects()
			self.arrayPlace.append("選択なし") //.add("選択なし")
			//self.arrayPlace.addObjectsFromArray(places as! [String])
			self.arrayPlace.append(contentsOf: places) //.addObjects(from: places)
			
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
				if HDZItemOrderManager.shared.charge == str {
					pickerposition = count
					break;
				}
				count += 1
			}
			self.pickerviewCharge.selectRow(pickerposition, inComponent: 0, animated: false)
			
			count = 0
			pickerposition = 0
			for str in self.arrayPlace {
				if HDZItemOrderManager.shared.deliverto == str {
					pickerposition = count
					break;
				}
				count += 1
			}
			self.pickerviewPlace.selectRow(pickerposition, inComponent: 0, animated: false)
			// end
		}
		
		// API
		let error: (_ error: Error?, _ unboxable: ItemError?) -> Void = { (error, unboxable) in

			self.request = nil
		}
		self.request = HDZApi.item(supplierId: supplierId, completionBlock: completion, errorBlock: error)
	}
}

// MARK: - Order
extension HDZItemOrderDialogViewController {

	func openCompleteDialog() {
		// ダイアログアクション
//		let action: UIAlertAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
//			
//			// タブ画面に戻る＝モーダルを閉じる
//			self.navigationController?.viewControllers[1].dismiss(animated: true) {
//
//				self.closeSelf()
//			}
//		}
//		let alert: UIAlertController = UIAlertController(title: "注文確定", message: nil, preferredStyle: .alert)
//		alert.addAction(action)
//		let basevc:UIViewController = MyWarning.getBaseViewController()
//		basevc.present(alert, animated: false, completion: nil)
		
		// 確認ダイアログ
		UIAlertController(title: "注文確定", message: nil, preferredStyle: .alert)
			.addAction(title: "OK", style: .default) { (UIAlertAction) in
				// タブ画面に戻る＝モーダルを閉じる
				self.navigationController?.viewControllers[1].dismiss(animated: true) {
					self.closeSelf()
				}
			}
			.show()
		
	}
	
	func closeSelf() {
		// 注文履歴タブへ遷移
		// 1.ルートビュー取得
		let rootvc:UIViewController = (UIApplication.shared.keyWindow?.rootViewController)!
		
		// 2.タブバーコントローラーチェック
		if rootvc.title == "HDZHomeViewController" {
			// 3.タブバータイテム選択
			let tabbarctrl:UITabBarController = rootvc as! UITabBarController
			tabbarctrl.selectedIndex = 1
		}
		
	}
	
	func doAfterComplete() {
		HDZItemOrderManager.shared.clearAllData()
		
		// カートを空にする
		for object in self.orderResult! {
			try! HDZOrder.deleteObject(object: object)
		}

		// FAX送信実行
		let completion:(_ unboxable: FaxResult?) -> Void = { (unboxable) in
			self.indicatorView.stopAnimating()
			
			guard let result:FaxResult = unboxable else {
				return
			}
			
			if result.result {
				debugPrint("FAX SEND COMPLETE")
			}
			else {
				debugPrint("FAX Not SEND")
			}
			
			self.openCompleteDialog()
		}
		let error: (_ error:Error?, _ unboxable:FaxError?) -> Void = { (error,unboxable) in
			self.indicatorView.stopAnimating()
			debugPrint(error.debugDescription)
			self.openCompleteDialog()
		}
		let _ = HDZApi.sendFax(orderNo: self.order_no, completeBlock: completion, errorBlock: error)
	}
	
	// 注文実行
	func didSelectedOrder() {
		self.orderResult = try! HDZOrder.queries(supplierId: self.supplierId)
		
		guard let items: Results<HDZOrder> = self.orderResult else {
			
			// アイテム無し
			let action: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			let controller: UIAlertController = UIAlertController(title: "アイテム無し", message: nil, preferredStyle: .alert)
			controller.addAction(action)
			self.present(controller, animated: true, completion: nil)
			
			return
		}
		
		//インジケータ
		self.indicatorView.startAnimating()
		
		let completion: (_ unboxable: OrderResult?) -> Void = { (unboxable) in
			
			// 注文確定
//			self.indicatorView.stopAnimating()
			
			// 注文結果取得
			guard let result: OrderResult = unboxable else {
				// エラー終了
				HDZItemOrderManager.shared.clearAllData()
				return
			}
			
			self.order_no = result.order_no
			
			// メッセージ送信チェック
			if HDZItemOrderManager.shared.comment == "" {
				self.doAfterComplete()
				return
			}
			
			// APIメッセージ送信
			let completion: (_ unboxable: MessageAddResult?) -> Void = { (unboxable) in
				self.doAfterComplete()
			}
			let error: (_ error: Error?, _ unboxable: MessageAddError?) -> Void = { (error, unboxable) in
				#if DEBUG
					debugPrint(error.debugDescription)
				#endif
				self.doAfterComplete()
			}
			self.request = HDZApi.adMessage(order_no: result.order_no, charge: HDZItemOrderManager.shared.charge, message: HDZItemOrderManager.shared.comment, completionBlock: completion, errorBlock: error)
		}
		
		let error: (_ error: Error?, _ unboxable: OrderError?) -> Void = { (error, unboxable) in
			
			// 注文エラー
			self.indicatorView.stopAnimating()
			
			let action: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			let controller: UIAlertController = UIAlertController(title: "注文エラー", message: error.debugDescription, preferredStyle: .alert)
			controller.addAction(action)
			self.present(controller, animated: true, completion: nil)
			
			// ボタン有効
			self.updateButtonEnabled(enabled: true)
		}
		
		// Request
		HDZApi.order(supplier_id: self.supplierId, deliver_to: HDZItemOrderManager.shared.deliverto, delivery_day: HDZItemOrderManager.shared.deliverdate, charge: HDZItemOrderManager.shared.charge, items: items, completionBlock: completion, errorBlock: error)
		
	}

}

// MARK: - Action
extension HDZItemOrderDialogViewController {
	
//	@IBAction func onCloseDialog(_ sender: Any) {
//		
//	}
//	
//	@IBAction func onSaveDialog(_ sender: Any) {
//		
//	}
	
	@IBAction func onSendOrder(_ sender: Any) {
		
		// TODO:注文実行
		// 配送情報
		// 1.担当者
		if HDZItemOrderManager.shared.charge == "" {
			// 担当者一覧
			let charges = self.itemResult.charge_list
			HDZItemOrderManager.shared.charge = charges[0]
		}
		// 3.配送日
		if HDZItemOrderManager.shared.deliverdate == "" {
			// 配送日一覧
			//let dates:[String] = HDZItemOrderManager.shared.getListDate()
			let dates = self.itemResult.delivery_day_list
			HDZItemOrderManager.shared.deliverdate = dates[0] // "最短納品日"
		}
		
		// 3.配送先は空白の場合ありなのでそのまま
		//		let place:String = HDZItemOrderManager.shared.deliverto
		
		// ボタン無効
		self.updateButtonEnabled(enabled: false)
		
		// 「注文しますか？」
		let cancelaction:UIAlertAction = UIAlertAction(title: "いいえ", style: .cancel) { (action:UIAlertAction!) in
			// キャンセル
			// ボタン有効
			self.updateButtonEnabled(enabled: true)
		}
		let confirmaction:UIAlertAction = UIAlertAction(title: "はい", style: .default) { (action:UIAlertAction!) in
			// 確定
			self.didSelectedOrder()
		}
		let alert:UIAlertController = UIAlertController(title:"注文",
		                                                message: "確定しますか？",
		                                                preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(cancelaction)
		alert.addAction(confirmaction)
		self.present(alert, animated: false, completion: nil)
	}
	
}

// MARK: - UITextViewDelegate
extension HDZItemOrderDialogViewController: UITextViewDelegate {
	
	func textViewDidChange(_ textView: UITextView) {
	//func textViewDidChange(textView: UITextView) {
		
		self.textviewComment.textChanged(notification: nil)
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
	//func textViewDidEndEditing(textView: UITextView) {
		HDZItemOrderManager.shared.comment = self.textviewComment.text
	}

}

// MARK: - UIPickerViewDataSource
extension HDZItemOrderDialogViewController: UIPickerViewDataSource {
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
	//func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
	//func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		
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
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
	//func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		
		if pickerView == self.pickerviewDate {
			// 必須
			HDZItemOrderManager.shared.deliverdate = self.arrayDate[row] 
		}
		else if pickerView == self.pickerviewCharge {
			// 必須
			HDZItemOrderManager.shared.charge = self.arrayCharge[row]
		}
		else if pickerView == self.pickerviewPlace {
			if row >= 1 {
				// 任意
				HDZItemOrderManager.shared.deliverto = self.arrayPlace[row]
			}
			else {
				// 空白
				HDZItemOrderManager.shared.deliverto = ""
			}
		}
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
	//func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
		if pickerView == self.pickerviewDate {
			return self.arrayDate[row]
		}
		if pickerView == self.pickerviewCharge {
			return self.arrayCharge[row]
		}
		if pickerView == self.pickerviewPlace {
			return self.arrayPlace[row]
		}

		return "aaa" //self.chargeList[row]
	}
	
}
