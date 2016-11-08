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
	
    private var countHistoryCategory:Int = 0
    
    // TODO:test
    private var orderdItemRequest:Alamofire.Request? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()

		// タイトル
		self.title = self.friendInfo.name

		// テーブルセル
		HDZItemCategoryTableViewCell.register(self.tableView)
		
		//インジケータ
		self.indicatorView = CustomIndicatorView.createView(self.view.frame.size)
		self.view.addSubview(self.indicatorView)
		
		// !!!:バッジ通知
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HDZItemCategoryTableViewController.getNotification(_:)), name: HDZPushNotificationManager.shared.strNotificationSupplier, object: nil)
    }

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		self.request?.resume()
		
		// API
		self.getItem(self.friendInfo.id)
	}

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.request?.suspend()
    }
	
    deinit {
        self.request?.cancel()
		
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

    // セクション数
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    // セクション内行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            // 新着（動的商品）
            if self.itemResult == nil || self.itemResult.dynamicItem == nil || self.itemResult.dynamicItem!.count <= 0 {
                return 0
            } else {
                return 1
            }
        case 1:
            // 静的商品カテゴリ
            return self.categoryName.count
        case 2:
            // 履歴から注文
            return countHistoryCategory
        default:
            return 0
        }
    }
    
    // セル作成
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
			// 新着（動的商品）
			let customcell:HDZItemCategoryTableViewCell = HDZItemCategoryTableViewCell.dequeueReusableCell(tableView, forIndexPath: indexPath)
			customcell.labelName.text = self.dynamicTitle
			return customcell
        case 2:
            // 履歴から注文
            let customcell:HDZItemCategoryTableViewCell = HDZItemCategoryTableViewCell.dequeueReusableCell(tableView, forIndexPath: indexPath)
            customcell.labelName.text = "履歴から注文"
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
	
    // 描画前
	override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		
		if indexPath.section == 0 {
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
		}
	}
}

// MARK: - Tableview delegate
extension HDZItemCategoryTableViewController {

    // 行選択
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
		switch indexPath.section {
        case 0:
			//動的商品
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
                // 遷移
				let controller:HDZItemStaticTableViewController = HDZItemStaticTableViewController.createViewController(self.itemResult.supplier.supplier_id,
				                                                                                                        attr_flg: self.itemResult.attr_flg,
				                                                                                                        categoryKey: keys[indexPath.row],
				                                                                                                        categoryName: category_name)
				
                self.navigationController?.pushViewController(controller, animated: true)                
            }
            break
        case 2:
            // 履歴から注文
            // TODO:画面遷移
//            getOrderdItem(self.itemResult.supplier.supplier_id)
            
            let controller:HDZItemOrderdHistoryTableViewController = HDZItemOrderdHistoryTableViewController.createViewController(self.itemResult.supplier.supplier_id, attr_flg: self.itemResult.attr_flg)
            self.navigationController?.pushViewController(controller, animated: true)
            break
        default:
            break
        }
    }
	
    // TODO:test
    private func getOrderdItem(supplierId: String) {
        
        self.refreshControl?.beginRefreshing()
        
        // インジケーター開始
//        self.indicatorView.startAnimating()
        
        let completion: (unboxable: OrderdItemResult?) -> Void = { (unboxable) in
            
//            self.request = nil
//            guard let result: ItemResult = unboxable else {
//                return
//            }
//            self.itemResult = result
            
            // 静的商品の登録
//            self.categoryItems = [:]
//            if let staticItems: [StaticItem] = result.staticItem {
//                for staticItem in staticItems {
//                    let index:Int = Int(staticItem.category.id)!
//                    
//                    if self.categoryItems[ index ] == nil {
//                        self.categoryItems[ index ] = [staticItem]
//                    } else {
//                        self.categoryItems[ index ]?.append(staticItem)
//                    }
//                }
//            }
//            self.staticItems = self.categoryItems[ self.categoryKey ]!
            // End
            
//            self.indicatorView.stopAnimating()
//            
//            self.refreshControl?.endRefreshing()
//            
//            self.tableView.reloadData()
        }
        
        let error: (error: ErrorType?, unboxable: ItemError?) -> Void = { (error, unboxable) in
            
//            self.indicatorView.stopAnimating()
//            
//            self.refreshControl?.endRefreshing()
//            
//            self.request = nil
        }
        
        // Request
        self.orderdItemRequest = HDZApi.orderd_item(supplierId, completionBlock: completion, errorBlock: error)
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
			
            self.countHistoryCategory = 1
            
            self.tableView.reloadData()
        }
        
        let error: (error: ErrorType?, unboxable: ItemError?) -> Void = { (error, unboxable) in
			
			self.indicatorView.stopAnimating()

            self.countHistoryCategory = 1

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


