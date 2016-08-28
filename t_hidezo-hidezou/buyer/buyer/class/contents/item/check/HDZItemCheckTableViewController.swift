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
	
    private var supplierId: Int = 0
    private var result: Results<HDZOrder>? = nil
	private var request: Alamofire.Request? = nil

	// !!!: dezami
	private var indicatorView:CustomIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "注文内容確認"
		
        HDZItemCheckCell.register(self.tableView)
		HDZItemCheckFractionCell.register(self.tableView)
		
		//インジケーター
		//let basevc:UIViewController = UIWarning.getBaseViewController(0)
		
		self.indicatorView = CustomIndicatorView.createView(self.view.frame.size)
		self.view.addSubview(self.indicatorView)
		
//        self.settingSendButton()
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
		}

	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Create
extension HDZItemCheckTableViewController {
    
    internal class func createViewController(supplierId: Int) -> HDZItemCheckTableViewController {
        let controller: HDZItemCheckTableViewController = UIViewController.createViewController("HDZItemCheckTableViewController")
        controller.supplierId = supplierId
        return controller
    }
    
//    private func settingSendButton() {
//		
////        let button: UIBarButtonItem = UIBarButtonItem(title: "注文する", style: .Done, target: self, action: #selector(HDZItemCheckTableViewController.didSelectedOrder))
////        self.navigationItem.setRightBarButtonItem(button, animated: true)
//		
//    }
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
			
			
			// メッセージ送信API
			guard let result: OrderResult = unboxable else {
				return
			}

			if HDZItemOrderManager.shared.comment == "" {
				return
			}
//			guard let message: String = HDZItemOrderManager.shared.comment else {
//				//self.sendCommentButton.enabled = true
//				return
//			}
			
			let completion: (unboxable: MessageAddResult?) -> Void = { (unboxable) in
				//self.dismissViewControllerAnimated(true, completion: nil)
			}
			
			let error: (error: ErrorType?, unboxable: MessageAddError?) -> Void = { (error, unboxable) in
				//self.dismissViewControllerAnimated(true, completion: nil)
				debugPrint(error)
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

extension HDZItemCheckTableViewController {
	
	@IBAction func onConfirmOrder(sender: AnyObject) {

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
		
		/*
		// 注文確定
		self.result = try! HDZOrder.queries(self.supplierId)
		
		guard let items: Results<HDZOrder> = self.result else {
			
			// アイテム無し
			let action: UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
			let controller: UIAlertController = UIAlertController(title: "アイテム無し", message: nil, preferredStyle: .Alert)
			controller.addAction(action)
			self.presentViewController(controller, animated: true, completion: nil)
			
			return
		}
		
		let completion: (unboxable: OrderResult?) -> Void = { (unboxable) in
			
			// 注文確定
			let action: UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
			let controller: UIAlertController = UIAlertController(title: "注文確定", message: nil, preferredStyle: .Alert)
			controller.addAction(action)
			self.presentViewController(controller, animated: true, completion: nil)
		}
		
		let error: (error: ErrorType?, unboxable: OrderError?) -> Void = { (error, unboxable) in
			
			// 注文エラー
			let action: UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
			let controller: UIAlertController = UIAlertController(title: "注文エラー", message: error.debugDescription, preferredStyle: .Alert)
			controller.addAction(action)
			self.presentViewController(controller, animated: true, completion: nil)
		}
		
		HDZApi.order(self.supplierId, deliver_to: "静岡", delivery_day: "明日", charge: "中本", items: items, completionBlock: completion, errorBlock: error)
		*/

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