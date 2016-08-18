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

    private var supplierId: Int = 0
    private var result: Results<HDZOrder>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "注文内容確認"
		
        HDZItemCheckCell.register(self.tableView)
        
        self.settingSendButton()
        self.loadItem()
    }

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		// !!!:デザミシステム
		// フッター
//		self.tableView.tableFooterView = HDZItemOrderConfirmFooter.createView(self, supplierId: 0, delegate: self)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HDZItemCheckTableViewController {
    
    internal class func createViewController(supplierId: Int) -> HDZItemCheckTableViewController {
        let controller: HDZItemCheckTableViewController = UIViewController.createViewController("HDZItemCheckTableViewController")
        controller.supplierId = supplierId
        return controller
    }
    
    private func settingSendButton() {
		
//        let button: UIBarButtonItem = UIBarButtonItem(title: "注文する", style: .Done, target: self, action: #selector(HDZItemCheckTableViewController.didSelectedOrder))
//        self.navigationItem.setRightBarButtonItem(button, animated: true)
		
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
        let cell: HDZItemCheckCell = HDZItemCheckCell.dequeueReusableCell(tableView, indexPath: indexPath, delegate: self)
		cell.parent = self

        cell.indexText.text = String(format: "%d", indexPath.row + 1)
        
        if let item: HDZOrder = self.result?[indexPath.row] {

            cell.order = item

			// 結果
			let completionHandler: (Response<NSData, NSError>) -> Void = { (response: Response<NSData, NSError>) in
				
				if response.result.error != nil {
//					NSLog("HDZItemCheckTableViewController")
//					NSLog("\(response.result.error.debugDescription)")
					
					//代替画像
					cell.iconImageView.image = UIImage(named: "sakana")
				}
				else {
					if let value: NSData = response.result.value {
						if let resultImage: UIImage = UIImage(data: value) {
							cell.iconImageView.image = resultImage
						}
					}
				}
			}
			let _: Alamofire.Request? = Alamofire.request(.GET, item.imageURL).responseData(completionHandler: completionHandler)
//			NSLog("HDZItemCheckTableViewController:requestImage")
//			NSLog("URL = \(item.imageURL)")
			
            cell.priceLabel.text = item.price
            cell.titleLabel.text = item.name
            cell.sizeLabel.text = String(format: "%d", item.size)
        }
        
        return cell
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
		
        let completion: (unboxable: OrderResult?) -> Void = { (unboxable) in
			// 注文確定
			
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
        }
        
        let error: (error: ErrorType?, unboxable: OrderError?) -> Void = { (error, unboxable) in
            
			// 注文エラー
			let action: UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
			let controller: UIAlertController = UIAlertController(title: "注文エラー", message: error.debugDescription, preferredStyle: .Alert)
			controller.addAction(action)
			self.presentViewController(controller, animated: true, completion: nil)
        }
        
        HDZApi.order(self.supplierId, deliver_to: "静岡", delivery_day: "明日", charge: "中本", items: items, completionBlock: completion, errorBlock: error)
    }
}

extension HDZItemCheckTableViewController: HDZItemCheckCellDelegate {
    
    func didSelectedDeleted() {
		
		//削除後に
        self.loadItem()
    }
}

extension HDZItemCheckTableViewController {
	
	@IBAction func onConfirmOrder(sender: AnyObject) {
		
		// 「注文しますか？」
		let cancelaction:UIAlertAction = UIAlertAction(title: "いいえ", style: .Cancel, handler: nil)
		let confirmaction:UIAlertAction = UIAlertAction(title: "はい", style: .Default) { (action:UIAlertAction!) in
			self.didSelectedOrder()
		}
		let alert:UIAlertController = UIAlertController(title:"注文",
		                                                message: "確定しますか？",
		                                                preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(cancelaction)
		alert.addAction(confirmaction)
		self.presentViewController(alert, animated: true, completion: nil)
		
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
		
		
	}
}