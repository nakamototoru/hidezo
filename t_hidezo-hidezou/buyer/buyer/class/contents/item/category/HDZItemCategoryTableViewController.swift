//
//  HDZItemCategoryTableViewController.swift
//  buyer
//
//  Created by NakaharaShun on 17/07/2016.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire

class HDZItemCategoryTableViewController: UITableViewController {

	@IBOutlet weak var barbuttonitemOrderCheck: UIBarButtonItem!
	
    private let dynamicTitle: String = "新着"
    private var categoryName: [Int : String] = [:]
    private var categoryItem: [Int: [StaticItem]] = [:]
	
    private var friendInfo: FriendInfo! = nil
    private var itemResult: ItemResult! = nil
    private var request: Alamofire.Request? = nil
	
	// !!!: dezami
	private var indicatorView:CustomIndicatorView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		// タイトル
		self.title = self.friendInfo.name

		// テーブルセル
		HDZItemCategoryTableViewCell.register(self.tableView)
		
		//インジケータ
		self.indicatorView = CustomIndicatorView.createView(self.view.frame.size)
		self.view.addSubview(self.indicatorView)
		
		// API
//		self.getItem(self.friendInfo.id)
		
		// !!!:バッジ通知
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HDZItemCategoryTableViewController.getNotification(_:)), name: HDZPushNotificationManager.shared.strNotificationSupplier, object: nil)
    }

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
//		self.request?.resume()
		
		// API
		self.getItem(self.friendInfo.id)
	}

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
//        self.request?.suspend()
    }
	
    deinit {
//        self.request?.cancel()
		
		//イベントリスナーの削除
		NSNotificationCenter.defaultCenter().removeObserver(self)
    }

	// !!!:通知受け取り時
	func getNotification(notification: NSNotification)  {
		
		self.tableView.reloadData()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Create
extension HDZItemCategoryTableViewController {
    
    internal class func createViewController(friendInfo: FriendInfo) -> HDZItemCategoryTableViewController {
        let controller: HDZItemCategoryTableViewController = UIViewController.createViewController("HDZItemCategoryTableViewController")
        controller.friendInfo = friendInfo
        return controller
    }
}

// MARK: - Table view data source
extension HDZItemCategoryTableViewController {

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if self.itemResult == nil || self.itemResult.dynamicItem == nil || self.itemResult.dynamicItem!.count <= 0 {
                return 0
            } else {
                return 1
            }
        case 1:
            return self.categoryName.count
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
			// 新着（動的商品）
			let customcell:HDZItemCategoryTableViewCell = HDZItemCategoryTableViewCell.dequeueReusableCell(tableView, forIndexPath: indexPath)
			customcell.labelName.text = self.dynamicTitle
            
			return customcell
			
        default:
			// 静的商品
			let customcell:HDZItemCategoryTableViewCell = HDZItemCategoryTableViewCell.dequeueReusableCell(tableView, forIndexPath: indexPath)
			if let keys: [Int] = self.categoryName.keys.sort() {
				customcell.labelName.text = self.categoryName[keys[indexPath.row]]
			}
			return customcell
        }
    }
	
	override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		
		if indexPath.section == 0 {
			#if true
			// 動的商品
			let customcell:HDZItemCategoryTableViewCell = cell as! HDZItemCategoryTableViewCell
			
			// !!!:バッジ表示判定
			let list:[SupplierId] = HDZPushNotificationManager.shared.getSupplierUpList()
			var badgeValue:Int = 0
			for obj:SupplierId in list {
				let id:String = obj.supplierId
				if id == friendInfo.id {
					badgeValue = 1
					break
				}
			}
			// !!!:バッジ表示
			customcell.putBadge( badgeValue )
			#endif
		}
		
	}

}

// MARK: - Tableview delegate
extension HDZItemCategoryTableViewController {

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		switch indexPath.section {
        case 0:
			//動的商品
			
//			// バッジ情報を消す
//			HDZPushNotificationManager.shared.removeSupplierUp(self.itemResult.supplier.supplier_id)
			
			// 遷移
			let controller: HDZItemDynamicTableViewController = HDZItemDynamicTableViewController.createViewController(self.itemResult.supplier.supplier_id, attr_flg: self.itemResult.attr_flg)
            self.navigationController?.pushViewController(controller, animated: true)
            break
        case 1:
			//静的商品
            if let keys: [Int] = self.categoryName.keys.sort() {
                guard let category_name: String = self.categoryName[keys[indexPath.row]] else {
                    return
                }
				let controller:HDZItemStaticTableViewController = HDZItemStaticTableViewController.createViewController(self.itemResult.supplier.supplier_id,
				                                                                                                        attr_flg: self.itemResult.attr_flg,
				                                                                                                        categoryKey: keys[indexPath.row],
				                                                                                                        categoryName: category_name)
				
                self.navigationController?.pushViewController(controller, animated: true)                
            }
            break
        default:
            break
        }
    }
	
}

// MARK: - API
extension HDZItemCategoryTableViewController {
    
    private func getItem(supplierId: String) {
		
		// インジケーター開始
		self.indicatorView.startAnimating()

        let completion: (unboxable: ItemResult?) -> Void = { (unboxable) in
            
            self.request = nil

            guard let result: ItemResult = unboxable else {
                return
            }
                        
            self.itemResult = result
			
			// 静的商品の登録
			self.categoryName = [:]
			self.categoryItem = [:]
            if let staticItems: [StaticItem] = result.staticItem {
				
                for staticItem in staticItems {
					
					let index:Int = Int(staticItem.category.id)!
                    self.categoryName[ index ] = staticItem.category.name
                    
                    if self.categoryItem[ index ] == nil {
                        self.categoryItem[ index ] = [staticItem]
                    } else {
                        self.categoryItem[ index ]?.append(staticItem)
                    }

                }
            }
			
			self.indicatorView.stopAnimating()
			
            self.tableView.reloadData()
        }
        
        let error: (error: ErrorType?, unboxable: ItemError?) -> Void = { (error, unboxable) in
			
			self.indicatorView.stopAnimating()

            self.request = nil
        }

		// Request
        self.request = HDZApi.item(supplierId, completionBlock: completion, errorBlock: error)

    }
	
	// モーダルビューに値を渡す
	internal func setupFriendInfo(friendInfo: FriendInfo) {
		self.friendInfo = friendInfo
	}
	
}

// MARK: - Action
extension HDZItemCategoryTableViewController {

	@IBAction func onCloseSelf(sender: AnyObject) {
		self.dismissViewControllerAnimated(true) {
			
		}
	}
	
	@IBAction func onCheckOrder(sender: AnyObject) {
		
		let controller: HDZItemCheckTableViewController = HDZItemCheckTableViewController.createViewController(self.friendInfo.id)
		self.navigationController?.pushViewController(controller, animated: true)
		
	}
}


