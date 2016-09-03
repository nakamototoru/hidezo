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
	
    private var supplierId: String = ""
    private var result: Results<HDZOrder>? = nil
	private var request: Alamofire.Request? = nil

	// !!!: dezami
	private var indicatorView:CustomIndicatorView!
	private var itemResult: ItemResult! = nil
	private var dynamicItemInfo: DynamicItemInfo!
	private var dynamicItem: [DynamicItem] = []
	private var attr_flg: AttrFlg = .other

	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "注文内容確認"
		
        HDZItemCheckCell.register(self.tableView)
		HDZItemCheckFractionCell.register(self.tableView)
		
		//インジケーター
		self.indicatorView = CustomIndicatorView.createView(self.view.frame.size)
		self.view.addSubview(self.indicatorView)
		
        self.loadItem()
    }

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		// !!!:デザミシステム
		if self.result?.count == 0 {
			// アイテム無しの場合
			let action2:UIAlertAction = UIAlertAction(title: "戻る", style: .Default, handler: { (action:UIAlertAction!) in
				self.navigationController?.popViewControllerAnimated(false)
			})
			let controller: UIAlertController = UIAlertController(title: "商品が選択されていません", message: "", preferredStyle: .Alert)
			controller.addAction(action2)
			self.presentViewController(controller, animated: false, completion: nil)
			
			return
		}

		self.getItem(self.supplierId)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
		
		let completion: (unboxable: ItemResult?) -> Void = { (unboxable) in
			
			self.request = nil
			
			guard let result: ItemResult = unboxable else {
				return
			}
			
			self.itemResult = result
			
			// 動的アイテム登録
			self.dynamicItemInfo = result.dynamicItemInfo![0]
			self.dynamicItem = result.dynamicItem!
			
			
			// インジケーター停止
			self.indicatorView.stopAnimating()
			
			//テーブル更新
//			self.tableView.reloadData()
//			self.tableView.tableHeaderView = HDZItemDynamicHeaderView.createView(self.dynamicItemInfo)
//			self.tableView.tableFooterView = HDZItemDynamicFooterView.createView(self.dynamicItemInfo, parent: self)
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
        if self.result == nil {
            return 0
        } else {
            return self.result!.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
        if let item: HDZOrder = self.result?[indexPath.row] {

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
    
    private func loadItem() {
        self.result = try! HDZOrder.queries(self.supplierId)

        self.tableView.reloadData()
    }
 
    internal func didSelectedOrder() {
        self.result = try! HDZOrder.queries(self.supplierId)

        guard let items: Results<HDZOrder> = self.result else {
			
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
			for object in self.result! {
				try! HDZOrder.deleteObject(object)
			}
			
			let action: UIAlertAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
				// ホームに戻る
				self.navigationController?.popToViewController((self.navigationController?.viewControllers.first)!, animated: true)
			}
			let controller: UIAlertController = UIAlertController(title: "注文確定", message: nil, preferredStyle: .Alert)
			controller.addAction(action)
			self.presentViewController(controller, animated: true, completion: nil)
			
			
			// メッセージ送信
			guard let result: OrderResult = unboxable else {
				HDZItemOrderManager.shared.clearAllData()
				return
			}

			if HDZItemOrderManager.shared.comment == "" {
				HDZItemOrderManager.shared.clearAllData()
				return
			}
			
			// API
			let completion: (unboxable: MessageAddResult?) -> Void = { (unboxable) in
				//self.dismissViewControllerAnimated(true, completion: nil)
				HDZItemOrderManager.shared.clearAllData()
			}
			let error: (error: ErrorType?, unboxable: MessageAddError?) -> Void = { (error, unboxable) in
				//self.dismissViewControllerAnimated(true, completion: nil)
				debugPrint(error)
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
			
			self.barbuttonitemConfirm.enabled = true;
        }


		// Request
        HDZApi.order(self.supplierId, deliver_to: HDZItemOrderManager.shared.deliverto, delivery_day: HDZItemOrderManager.shared.deliverdate, charge: HDZItemOrderManager.shared.charge, items: items, completionBlock: completion, errorBlock: error)
		
    }
}

// MARK: -
extension HDZItemCheckTableViewController: HDZItemCheckCellDelegate {
    
    func didSelectedDeleted() {
		
		//削除後に
        self.loadItem()
		
		// !!!:デザミシステム
		if self.result?.count == 0 {
			// アイテム無しの場合
			let action2:UIAlertAction = UIAlertAction(title: "戻る", style: .Default, handler: { (action:UIAlertAction!) in
				self.navigationController?.popViewControllerAnimated(false)
			})
			let controller: UIAlertController = UIAlertController(title: "商品が選択されていません", message: "", preferredStyle: .Alert)
			controller.addAction(action2)
			self.presentViewController(controller, animated: false, completion: nil)
		}

    }
	
	func itemcheckcellReload() {
		
		self.loadItem()
		
		// !!!:デザミシステム
		if self.result?.count == 0 {
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

		// 配送情報
		let charge:String = HDZItemOrderManager.shared.charge
		let place:String = HDZItemOrderManager.shared.deliverto
		let ddate:String = HDZItemOrderManager.shared.deliverdate
		if charge == "" || place == "" || ddate == "" {
			UIWarning.Warning("配送情報を入力して下さい。")
			
			return
		}
		
		self.barbuttonitemConfirm.enabled = false
		
		// 「注文しますか？」
		let cancelaction:UIAlertAction = UIAlertAction(title: "いいえ", style: .Cancel) { (action:UIAlertAction!) in
			self.barbuttonitemConfirm.enabled = true;
		}
		let confirmaction:UIAlertAction = UIAlertAction(title: "はい", style: .Default) { (action:UIAlertAction!) in
			self.didSelectedOrder()
		}
		let alert:UIAlertController = UIAlertController(title:"注文",
		                                                message: "確定しますか？",
		                                                preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(cancelaction)
		alert.addAction(confirmaction)
		self.presentViewController(alert, animated: false, completion: nil)

	}
	
	@IBAction func onBackHome(sender: AnyObject) {

		// ホームに戻る
		self.navigationController?.popToViewController((self.navigationController?.viewControllers.first)!, animated: true)
	}
	
	@IBAction func onCommentDialog(sender: AnyObject) {
		
		// モーダルで開く
		let controller:HDZItemOrderNavigationController = HDZItemOrderNavigationController.createViewController()
		controller.supplierId = self.supplierId
		self.navigationController?.presentViewController(controller, animated: true, completion: {
			
		})

	}
}