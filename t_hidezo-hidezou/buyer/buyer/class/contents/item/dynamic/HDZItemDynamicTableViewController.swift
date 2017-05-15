//
//  HDZItemDynamicTableViewController.swift
//  buyer
//
//  Created by NakaharaShun on 17/07/2016.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire

class HDZItemDynamicTableViewController: UITableViewController {
    
	var dynamicItemInfo: DynamicItemInfo!
	var dynamicItem: [DynamicItem] = []
	var attr_flg: AttrFlg = .other
	var supplierId: String = ""
	
	var itemResult: ItemResult! = nil
	var request: Alamofire.Request? = nil
	var categoryName: [Int : String] = [:]
	var categoryItem: [Int: [StaticItem]] = [:]

	// !!!: dezami
	var indicatorView:CustomIndicatorView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        HDZItemDynamicCell.register(tableView: self.tableView)
		HDZItemDynamicFractionCell.register(tableView: self.tableView)
		
		// 再読込イベント
		let refreshControl: UIRefreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(reloadRequest), for: .valueChanged)
		self.refreshControl = refreshControl

		//インジケータ
		self.indicatorView = CustomIndicatorView.createView(framesize: self.view.frame.size)
		self.view.addSubview(self.indicatorView)

    }

//	override func viewWillAppear(animated: Bool) {
//		super.viewWillAppear(animated)
//		
//	}
	
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
		
		self.request?.resume()
		
//		self.tableView.reloadData()
		self.getItem(supplierId: self.supplierId)
    }
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		self.request?.suspend()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	deinit {
		self.request?.cancel()
	}

	func reloadRequest() {
		self.getItem(supplierId: self.supplierId)
	}
}

// MARK: - Create
extension HDZItemDynamicTableViewController {
    
    internal class func createViewController(dynamicItemInfo: DynamicItemInfo, dynamicItem: [DynamicItem], attr_flg: AttrFlg, supplierId: String) -> HDZItemDynamicTableViewController {
        let controller: HDZItemDynamicTableViewController = UIViewController.createViewController(name: "HDZItemDynamicTableViewController")
        controller.dynamicItem = dynamicItem
        controller.dynamicItemInfo = dynamicItemInfo
        controller.attr_flg = attr_flg
        controller.supplierId = supplierId
        return controller
    }
	
	internal class func createViewController(supplierId: String, attr_flg: AttrFlg) -> HDZItemDynamicTableViewController {
		let controller: HDZItemDynamicTableViewController = UIViewController.createViewController(name: "HDZItemDynamicTableViewController")
		controller.supplierId = supplierId
		controller.attr_flg = attr_flg
		return controller
	}
}

// MARK: - API
extension HDZItemDynamicTableViewController {
	
	func getItem(supplierId: String) {
		
		self.refreshControl?.beginRefreshing()

		// インジケーター開始
		self.indicatorView.startAnimating()
		
		let completion: (_ unboxable: ItemResult?) -> Void = { (unboxable) in
			
			self.request = nil
			guard let result: ItemResult = unboxable else {
				return
			}
			self.itemResult = result

			// 動的アイテム登録
			if result.dynamicItemInfo != nil && (result.dynamicItemInfo?.count)! > 0 {
				self.dynamicItemInfo = result.dynamicItemInfo![0]
			}
			if result.dynamicItems != nil {
				self.dynamicItem = result.dynamicItems!
			}
			
			self.refreshControl?.endRefreshing()

			// インジケーター停止
			self.indicatorView.stopAnimating()
			
			//テーブル更新
			self.tableView.reloadData()
			self.tableView.tableHeaderView = HDZItemDynamicHeaderView.createView(dynamicItemInfo: self.dynamicItemInfo)
			self.tableView.tableFooterView = HDZItemDynamicFooterView.createView(dynamicItemInfo: self.dynamicItemInfo, parent: self)
			
			// バッジ情報を消す
			HDZPushNotificationManager.shared.removeSupplierUp(supplier_id: supplierId)
			let completion2:(_ unboxable: CheckDynamicItemsResultComplete?) -> Void = { (unboxable) in
				#if DEBUG
					debugPrint(unboxable.debugDescription)
				#endif
			}
			let error2:(_ error: Error?, _ unboxable: CheckDynamicItemsResultError?) -> Void = { (error,unboxable) in
				debugPrint(error.debugDescription)
			}
			let _ = HDZApi.postCheckDynamicItems(supplier_id: supplierId, completionBlock: completion2, errorBlock: error2)

			// OSバッジ
			HDZPushNotificationManager.updateBadgeInHomeIcon()
		}
		let error: (_ error: Error?, _ unboxable: ItemError?) -> Void = { (error, unboxable) in
			
			self.refreshControl?.endRefreshing()

			self.indicatorView.stopAnimating()
			
			self.request = nil
		}
		// Request
		self.request = HDZApi.item(supplierId: supplierId, completionBlock: completion, errorBlock: error)
	}

}

// MARK: - Table view data source
extension HDZItemDynamicTableViewController {
	
	override func numberOfSections(in tableView: UITableView) -> Int {
//	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dynamicItem.count
    }
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	//func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let item: DynamicItem = self.dynamicItem[indexPath.row]
		
		// 整数かどうかチェック
        var isInt: Bool = true
        if item.num_scale.count > 0 {
            if let _: Int = Int(item.num_scale[0]) {
                //整数
            } else {
				//分数
                isInt = false
            }
        }
		
		//let prices:[String] = item.price.componentsSeparatedByString(",")
		let pricetext:String = item.price //"その他:" + prices[0] + "円＿グループ:" + prices[1] + "円＿直営店:" + prices[2] + "円"
		
        if isInt {
			// 整数セル
            let cell: HDZItemDynamicCell = HDZItemDynamicCell.dequeueReusableCell(tableView: tableView, forIndexPath: indexPath, dynamicItem: item, attr_flg: self.attr_flg, supplierId: self.supplierId)
            cell.indexLabel.text = String(format: "%d", indexPath.row + 1)
            cell.itemName.text = item.item_name
			// 価格設定は３つに分かれている
			cell.priceLabel.text = pricetext
			
            if let item: HDZOrder = try! HDZOrder.queries(supplierId: supplierId, itemId: item.id, dynamic: true) {
                cell.itemsize = item.size
            }
			else {
				cell.itemsize = "0"
			}

            return cell
        }
		else {
			// 分数セル
            let cell: HDZItemDynamicFractionCell = HDZItemDynamicFractionCell.dequeueReusableCell(tableView: tableView, forIndexPath: indexPath, dynamicItem: item, attr_flg: self.attr_flg, supplierId: self.supplierId)
			cell.parent = self
            cell.indexLabel.text = String(format: "%d", indexPath.row + 1)
            cell.itemName.text = item.item_name
			// 価格設定は３つに分かれている
			cell.priceLabel.text = pricetext
			
            if let item: HDZOrder = try! HDZOrder.queries(supplierId: supplierId, itemId: item.id, dynamic: true) {
                cell.itemsize = item.size
            }
			else {
				cell.itemsize = "0"
			}

            return cell
        }
    }
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
	//func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		return HDZItemDynamicCell.getHeight()
	}
}

// MARK: - Action
extension HDZItemDynamicTableViewController {
	
	@IBAction func onCheckOrder(_ sender: Any) {
		
		let controller: HDZItemCheckTableViewController = HDZItemCheckTableViewController.createViewController(supplierId: self.supplierId)
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	@IBAction func onBackHome(_ sender: Any) {
		
		self.navigationController?.popToViewController((self.navigationController?.viewControllers.first)!, animated: true)
	}

}
