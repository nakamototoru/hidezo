//
//  HDZItemCheckTableViewController.swift
//  buyer
//
//  Created by Shun Nakahara on 8/1/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class HDZItemCheckTableViewController: UITableViewController {

	@IBOutlet weak var barbuttonitemConfirm: UIBarButtonItem!
//	@IBOutlet weak var barbuttonitemNote: UIBarButtonItem!
	@IBOutlet weak var barbuttonitemHome: UIBarButtonItem!
	
    private var supplierId: String = ""
	private var request: Alamofire.Request? = nil
	private var orderResult: Results<HDZOrder>? = nil

	// !!!: dezami
	private var indicatorView:CustomIndicatorView!
	private var itemResult: ItemResult! = nil
//	private var dynamicItemInfo: DynamicItemInfo!
	private var dynamicItems: [DynamicItem] = []
	private var attr_flg: AttrFlg = .other
	private var staticItems:[StaticItem] = []

	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "注文内容確認"
		
        HDZItemCheckCell.register(self.tableView)
		HDZItemCheckFractionCell.register(self.tableView)
		
		//インジケーター
		self.indicatorView = CustomIndicatorView.createView(self.view.frame.size)
		self.view.addSubview(self.indicatorView)
		
		// Realm（ローカルSQL）
//        self.loadItem()
		
		// ボタン無効
		self.updateButtonEnabled(false)
    }

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		// Realm（ローカルSQL）
		self.orderResult = try! HDZOrder.queries(self.supplierId)

		// !!!:デザミシステム
		if self.orderResult?.count == 0 {
			// アイテム無しの場合
			self.updateButtonEnabled(false)
			self.openAlertNoCart()
			
			return
		}

		// API
		self.getItem(self.supplierId)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// ボタン状態
	private func updateButtonEnabled(enabled:Bool) {
		self.barbuttonitemConfirm.enabled = enabled
//		self.barbuttonitemNote.enabled = enabled
		self.barbuttonitemHome.enabled = enabled
	}
}

// MARK: - Create
extension HDZItemCheckTableViewController {
    
    internal class func createViewController(supplierId: String) -> HDZItemCheckTableViewController {
        let controller: HDZItemCheckTableViewController = UIViewController.createViewController("HDZItemCheckTableViewController")
        controller.supplierId = supplierId
        return controller
    }

}

// MARK: - API
extension HDZItemCheckTableViewController {
	
	private func getItem(supplierId: String) {
		
		// インジケーター開始
		self.indicatorView.startAnimating()
		
		// ボタン無効
		self.updateButtonEnabled(false)
		
		let completion: (unboxable: ItemResult?) -> Void = { (unboxable) in
			
			self.request = nil
			guard let result: ItemResult = unboxable else {
				return
			}
			self.itemResult = result
			// 動的アイテム登録
			if result.dynamicItem != nil {
				self.dynamicItems = result.dynamicItem!
			}
			// 静的商品登録
			if result.staticItem != nil {
				self.staticItems = result.staticItem!
			}
			
			// カートチェック
			for order:HDZOrder in self.orderResult! {
				// 動的から
				var isEqual:Bool = false
				for item:DynamicItem in self.dynamicItems {
					if order.itemId == item.id {
						isEqual = true
						break;
					}
				}
				if (isEqual) {
					// 見つかったので次へ
					continue
				}
				
				// 見つからなかったら静的を
				for item:StaticItem in self.staticItems {
					if order.itemId == item.id {
						isEqual = true
						break;
					}
				}
				if (isEqual) {
					// 見つかったので次へ
					continue
				}

				// 存在しない商品だった場合は削除
				#if DEBUG
					debugPrint("存在しない静的商品：ID=" + order.id)
				#endif
				try! HDZOrder.deleteObject(order)
			}
			
			// カート更新
			self.orderResult = try! HDZOrder.queries(self.supplierId)
			//テーブル更新
			self.tableView.reloadData()

			// インジケーター停止
			self.indicatorView.stopAnimating()

			if self.orderResult?.count == 0 {
				// アイテム無しの場合
				self.openAlertNoCart()
				
				return
			}
			
			// ボタン有効
			self.updateButtonEnabled(true)
		}
		
		let error: (error: ErrorType?, unboxable: ItemError?) -> Void = { (error, unboxable) in
			
			self.indicatorView.stopAnimating()
			self.request = nil
		}
		// Request
		self.request = HDZApi.item(supplierId, completionBlock: completion, errorBlock: error)
	}

}

// MARK: - Table view data source
extension HDZItemCheckTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.orderResult == nil {
            return 0
        } else {
            return self.orderResult!.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
        if let item: HDZOrder = self.orderResult?[indexPath.row] {

			// 整数かどうかチェック
			if let _: Int = Int(item.size) {
				//整数
				let cell: HDZItemCheckCell = HDZItemCheckCell.dequeueReusableCell(tableView, indexPath: indexPath, delegate: self)
				
				cell.parent = self
				cell.indexText.text = String(format: "%d", indexPath.row + 1)
				cell.order = item
				cell.titleLabel.text = item.name
				cell.sizeLabel.text = item.size
				
				return cell
			}
			else {
				//分数
				let cell: HDZItemCheckFractionCell = HDZItemCheckFractionCell.dequeueReusableCell(tableView, indexPath: indexPath, delegate: self)
				
				cell.parent = self
				cell.indexText.text = String(format: "%d", indexPath.row + 1)
				cell.order = item
				cell.titleLabel.text = item.name
				cell.sizeLabel.text = item.size
				
				return cell
			}
        }
		else {
			return HDZItemCheckCell.dequeueReusableCell(tableView, indexPath: indexPath, delegate: self)
		}
        
    }
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		return HDZItemCheckCell.getHeight()
	}

}

// MARK: - Order
extension HDZItemCheckTableViewController {
    
//    private func loadItem() {
//        self.result = try! HDZOrder.queries(self.supplierId)
//
//        self.tableView.reloadData()
//    }
 
	private func openAlertNoCart() {
		
		// アラートビュー
		let action2:UIAlertAction = UIAlertAction(title: "戻る", style: .Default, handler: { (action:UIAlertAction!) in
			// 画面戻る
			self.navigationController?.popViewControllerAnimated(false)
		})
		let controller: UIAlertController = UIAlertController(title: "商品が選択されていません", message: "", preferredStyle: .Alert)
		controller.addAction(action2)
		self.presentViewController(controller, animated: false, completion: nil)
	}
	
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
				// ホームに戻る
				self.navigationController?.popToViewController((self.navigationController?.viewControllers.first)!, animated: true)
			}
			let controller: UIAlertController = UIAlertController(title: "注文確定", message: nil, preferredStyle: .Alert)
			controller.addAction(action)
			self.presentViewController(controller, animated: true, completion: nil)
			
			
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

// MARK: - HDZItemCheckCellDelegate
extension HDZItemCheckTableViewController: HDZItemCheckCellDelegate {

	func itemcheckcellReload() {
		
//		self.loadItem()
		self.orderResult = try! HDZOrder.queries(self.supplierId)
		self.tableView.reloadData()
		
		// !!!:デザミシステム
		if self.orderResult?.count == 0 {
			// アイテム無しの場合
			let action2:UIAlertAction = UIAlertAction(title: "戻る", style: .Default, handler: { (action:UIAlertAction!) in
				self.navigationController?.popViewControllerAnimated(false)
			})
			let controller: UIAlertController = UIAlertController(title: "商品が選択されていません", message: "", preferredStyle: .Alert)
			controller.addAction(action2)
			self.presentViewController(controller, animated: false, completion: nil)
		}
	}
}

// MARK: - Action
extension HDZItemCheckTableViewController {
	
	@IBAction func onConfirmOrder(sender: AnyObject) {

		// 入力画面
		let controller:HDZItemOrderDialogViewController = HDZItemOrderDialogViewController.createViewController(self.supplierId)
		controller.supplierId = self.supplierId
		self.navigationController?.pushViewController(controller, animated: true)

	}
	
	@IBAction func onBackHome(sender: AnyObject) {

		// ホームに戻る
		self.navigationController?.popToViewController((self.navigationController?.viewControllers.first)!, animated: true)
	}

}