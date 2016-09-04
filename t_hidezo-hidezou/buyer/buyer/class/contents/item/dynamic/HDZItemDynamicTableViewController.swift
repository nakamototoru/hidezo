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
    
    private var dynamicItemInfo: DynamicItemInfo!
    private var dynamicItem: [DynamicItem] = []
    private var attr_flg: AttrFlg = .other
    private var supplierId: String = ""
	
	private var itemResult: ItemResult! = nil
	private var request: Alamofire.Request? = nil
	private var categoryName: [Int : String] = [:]
	private var categoryItem: [Int: [StaticItem]] = [:]

	// !!!: dezami
	private var indicatorView:CustomIndicatorView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        HDZItemDynamicCell.register(self.tableView)
		HDZItemDynamicFractionCell.register(self.tableView)
		
		//インジケータ
		self.indicatorView = CustomIndicatorView.createView(self.view.frame.size)
		self.view.addSubview(self.indicatorView)

    }

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
//		self.tableView.tableHeaderView = HDZItemDynamicHeaderView.createView(self.dynamicItemInfo)
//		self.tableView.tableFooterView = HDZItemDynamicFooterView.createView(self.dynamicItemInfo, parent: self)
	}
	
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
		
//		self.tableView.reloadData()
		self.getItem(self.supplierId)
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Create
extension HDZItemDynamicTableViewController {
    
    internal class func createViewController(dynamicItemInfo: DynamicItemInfo, dynamicItem: [DynamicItem], attr_flg: AttrFlg, supplierId: String) -> HDZItemDynamicTableViewController {
        let controller: HDZItemDynamicTableViewController = UIViewController.createViewController("HDZItemDynamicTableViewController")
        controller.dynamicItem = dynamicItem
        controller.dynamicItemInfo = dynamicItemInfo
        controller.attr_flg = attr_flg
        controller.supplierId = supplierId
        return controller
    }
	
	internal class func createViewController(supplierId: String, attr_flg: AttrFlg) -> HDZItemDynamicTableViewController {
		let controller: HDZItemDynamicTableViewController = UIViewController.createViewController("HDZItemDynamicTableViewController")
		controller.supplierId = supplierId
		controller.attr_flg = attr_flg
		return controller
	}
}

// MARK: - API
extension HDZItemDynamicTableViewController {
	
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
			if result.dynamicItemInfo != nil && result.dynamicItemInfo?.count > 0 {
				self.dynamicItemInfo = result.dynamicItemInfo![0]
			}
			if result.dynamicItem != nil {
				self.dynamicItem = result.dynamicItem!
			}
			
			// インジケーター停止
			self.indicatorView.stopAnimating()
			
			//テーブル更新
			self.tableView.reloadData()
			self.tableView.tableHeaderView = HDZItemDynamicHeaderView.createView(self.dynamicItemInfo)
			self.tableView.tableFooterView = HDZItemDynamicFooterView.createView(self.dynamicItemInfo, parent: self)
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
extension HDZItemDynamicTableViewController {
	
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
	
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dynamicItem.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
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
            let cell: HDZItemDynamicCell = HDZItemDynamicCell.dequeueReusableCell(tableView, forIndexPath: indexPath, dynamicItem: item, attr_flg: self.attr_flg, supplierId: self.supplierId)
            cell.indexLabel.text = String(format: "%d", indexPath.row + 1)
            cell.itemName.text = item.item_name
			// 価格設定は３つに分かれている
			cell.priceLabel.text = pricetext
			
            if let item: HDZOrder = try! HDZOrder.queries(supplierId, itemId: item.id, dynamic: true) {
                cell.itemsize = item.size
            }
			else {
				cell.itemsize = "0"
			}

            return cell
        }
		else {
			// 分数セル
            let cell: HDZItemDynamicFractionCell = HDZItemDynamicFractionCell.dequeueReusableCell(tableView, forIndexPath: indexPath, dynamicItem: item, attr_flg: self.attr_flg, supplierId: self.supplierId)
			cell.parent = self
            cell.indexLabel.text = String(format: "%d", indexPath.row + 1)
            cell.itemName.text = item.item_name
			// 価格設定は３つに分かれている
			cell.priceLabel.text = pricetext
			
            if let item: HDZOrder = try! HDZOrder.queries(supplierId, itemId: item.id, dynamic: true) {
                cell.itemsize = item.size
            }
			else {
				cell.itemsize = "0"
			}

            return cell
        }
    }
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		return HDZItemDynamicCell.getHeight()
	}
}

// MARK: - Action
extension HDZItemDynamicTableViewController {
	
	@IBAction func onCheckOrder(sender: AnyObject) {
		
		let controller: HDZItemCheckTableViewController = HDZItemCheckTableViewController.createViewController(self.supplierId)
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	@IBAction func onBackHome(sender: AnyObject) {
		
		self.navigationController?.popToViewController((self.navigationController?.viewControllers.first)!, animated: true)
	}

}
