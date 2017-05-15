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
	
	let dynamicTitle: String = "新着"
	var categoryName: [Int : String] = [:]
	var categoryItem: [Int: [StaticItem]] = [:]
	
	var friendInfo: FriendInfo! = nil
	var itemResult: ItemResult! = nil
	var request: Alamofire.Request? = nil
	
	// !!!: dezami
	var indicatorView:CustomIndicatorView!
	
	var countHistoryCategory:Int = 0
    
    // TODO:test
	var orderdItemRequest:Alamofire.Request? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()

		// タイトル
		self.title = self.friendInfo.name

		// テーブルセル
		HDZItemCategoryTableViewCell.register(tableView: self.tableView)
		
		//インジケータ
		self.indicatorView = CustomIndicatorView.createView(framesize: self.view.frame.size)
		self.view.addSubview(self.indicatorView)
		
		// !!!:バッジ通知
		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(HDZItemCategoryTableViewController.getNotification),
		                                       name: HDZPushNotificationManager.shared.strNotificationSupplier,
		                                       object: nil)
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		self.request?.resume()
		
		// API
		self.getItem(supplierId: self.friendInfo.id)
	}

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.request?.suspend()
    }
	
    deinit {
        self.request?.cancel()
		
		//イベントリスナーの削除
		NotificationCenter.default.removeObserver(self)
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
        let controller: HDZItemCategoryTableViewController = UIViewController.createViewController(name: "HDZItemCategoryTableViewController")
        controller.friendInfo = friendInfo
        return controller
    }
}

// MARK: - Table view data source
extension HDZItemCategoryTableViewController {

    // セクション数
//	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 3
//    }
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			// 新着（動的商品）
			if self.itemResult == nil || self.itemResult.dynamicItems == nil || self.itemResult.dynamicItems!.count <= 0 {
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
    // セクション内行数
//	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//  }
	
    // セル作成
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	//func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
			// 新着（動的商品）
			let customcell:HDZItemCategoryTableViewCell = HDZItemCategoryTableViewCell.dequeueReusableCell(tableView: tableView, forIndexPath: indexPath)
			customcell.labelName.text = self.dynamicTitle
			return customcell
        case 2:
            // 履歴から注文
            let customcell:HDZItemCategoryTableViewCell = HDZItemCategoryTableViewCell.dequeueReusableCell(tableView: tableView, forIndexPath: indexPath)
            customcell.labelName.text = "履歴から注文"
            return customcell
        default:
			// 静的商品
			let customcell:HDZItemCategoryTableViewCell = HDZItemCategoryTableViewCell.dequeueReusableCell(tableView: tableView, forIndexPath: indexPath)
			let sortKeys = self.categoryName.keys.sorted()
			customcell.labelName.text = self.categoryName[sortKeys[indexPath.row]]

//			if let keys: [Int] = self.categoryName.keys.sorted() {
//				customcell.labelName.text = self.categoryName[keys[indexPath.row]]
//			}
			return customcell
        }
    }
	
    // 描画前
	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
	//func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
		
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
			customcell.putBadge( value: badgeValue )
		}
	}
}

// MARK: - Tableview delegate
extension HDZItemCategoryTableViewController {

    // 行選択
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	//func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
		
        tableView.deselectRow(at: indexPath, animated: false)
        
		switch indexPath.section {
        case 0:
			//動的商品
			// 遷移
			let controller: HDZItemDynamicTableViewController
				= HDZItemDynamicTableViewController.createViewController(supplierId: self.itemResult.supplier.supplier_id,
				                                                         attr_flg: self.itemResult.attr_flg)
            self.navigationController?.pushViewController(controller, animated: true)
            break
        case 1:
			//静的商品
			let keys = self.categoryName.keys.sorted()
//            if let keys: [Int] = self.categoryName.keys.sorted() {
                guard let category_name: String = self.categoryName[keys[indexPath.row]] else {
                    return
                }
                // 遷移
				let controller:HDZItemStaticTableViewController
					= HDZItemStaticTableViewController.createViewController(supplierId: self.itemResult.supplier.supplier_id,
					                                                        attr_flg: self.itemResult.attr_flg,
					                                                        categoryKey: keys[indexPath.row],
					                                                        categoryName: category_name)
				
                self.navigationController?.pushViewController(controller, animated: true)                
//            }
            break
        case 2:
            // 履歴から注文
            let controller:HDZItemOrderdHistoryTableViewController
				= HDZItemOrderdHistoryTableViewController.createViewController(supplierId: self.itemResult.supplier.supplier_id,
				                                                               attr_flg: self.itemResult.attr_flg)
            self.navigationController?.pushViewController(controller, animated: true)
            break
        default:
            break
        }
    }
	
}

// MARK: - API
extension HDZItemCategoryTableViewController {
    
	func getItem(supplierId: String) {
		
		// インジケーター開始
		self.indicatorView.startAnimating()

        let completion: (_ unboxable: ItemResult?) -> Void = { (unboxable) in
            
            self.request = nil

            guard let result: ItemResult = unboxable else {
                return
            }
                        
            self.itemResult = result
			
			// 静的商品の登録
			self.categoryName = [:]
			self.categoryItem = [:]
            if let staticItems: [StaticItem] = result.staticItems {
				
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
        
        let error: (_ error: Error?, _ unboxable: ItemError?) -> Void = { (error, unboxable) in
			
			self.indicatorView.stopAnimating()

            self.countHistoryCategory = 1

            self.request = nil
        }

		// Request
        self.request = HDZApi.item(supplierId: supplierId, completionBlock: completion, errorBlock: error)

    }
	
	// モーダルビューに値を渡す
	internal func setupFriendInfo(friendInfo: FriendInfo) {
		self.friendInfo = friendInfo
	}
	
}

// MARK: - Action
extension HDZItemCategoryTableViewController {

	@IBAction func onCloseSelf(_ sender: Any) {
		self.dismiss(animated: true) {
			
		}
	}
	
	@IBAction func onCheckOrder(_ sender: Any) {
		
		let controller: HDZItemCheckTableViewController = HDZItemCheckTableViewController.createViewController(supplierId: self.friendInfo.id)
		self.navigationController?.pushViewController(controller, animated: true)
		
	}
}


