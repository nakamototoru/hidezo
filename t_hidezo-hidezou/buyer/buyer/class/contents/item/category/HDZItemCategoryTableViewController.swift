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
	
    private let dynamicTitle: String = "新着" // "動的商品"
    private var categoryName: [Int : String] = [:]
    private var categoryItem: [Int: [StaticItem]] = [:]
    
    private var friendInfo: FriendInfo! = nil
    private var itemResult: ItemResult! = nil
    private var request: Alamofire.Request? = nil
	
	// !!!: dezami
	private var indicatorView:CustomIndicatorView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// !!!:デザミシステム
//		let button:UIButton = UIButton(type: UIButtonType.Custom)
//		button.setTitle("確認", forState: UIControlState.Normal)
//		button.layer.backgroundColor = UIColor.greenColor().CGColor
//		
////		let testview:UIView = UIView()
////		testview.backgroundColor = UIColor.greenColor()
////		testview.frame = CGRectMake(0, 0, 200, 80)
////		self.barbuttonitemOrderCheck.customView = button
//		let buttonitem:UIBarButtonItem = UIBarButtonItem(customView: button)
//		self.toolbarItems = [buttonitem]
		
		// テーブルセル
		HDZItemCategoryTableViewCell.register(self.tableView)
		
		//インジケータ
		self.indicatorView = CustomIndicatorView.createView(self.view.frame.size)
		self.view.addSubview(self.indicatorView)
		
		// API
		self.getItem(self.friendInfo.id)
		
		self.title = self.friendInfo.name
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.request?.suspend()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        self.request?.resume()
    }
	
    deinit {
        self.request?.cancel()
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
			// おすすめ（動的商品）
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
	

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
        switch indexPath.section {
        case 0:
			//動的商品
            let controller: HDZItemDynamicTableViewController = HDZItemDynamicTableViewController.createViewController(self.itemResult.dynamicItemInfo![0], dynamicItem: self.itemResult.dynamicItem!, attr_flg: self.itemResult.attr_flg, supplierId: self.itemResult.supplier.supplier_id)
            self.navigationController?.pushViewController(controller, animated: true)
            break
        case 1:
			//静的商品
            if let keys: [Int] = self.categoryName.keys.sort() {
                guard let categoryName: String = self.categoryName[keys[indexPath.row]] else {
                    return
                }
                
                guard let categoryItem: [StaticItem] = self.categoryItem[keys[indexPath.row]] else {
                    return
                }
                
                let controller: HDZItemStaticTableViewController = HDZItemStaticTableViewController.createViewController(categoryName, categoryItems: categoryItem, attr_flg: self.itemResult.attr_flg, supplierId: self.itemResult.supplier.supplier_id)
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
    
    private func getItem(supplierId: Int) {
		
		// インジケーター開始
		self.indicatorView.startAnimating()

        let completion: (unboxable: ItemResult?) -> Void = { (unboxable) in
            
            self.request = nil

            guard let result: ItemResult = unboxable else {
                return
            }
                        
            self.itemResult = result
            
            if let staticItems: [StaticItem] = result.staticItem {
                for staticItem in staticItems {
                    self.categoryName[staticItem.category.id] = staticItem.category.name
                    
                    if self.categoryItem[staticItem.category.id] == nil {
                        self.categoryItem[staticItem.category.id] = [staticItem]
                    } else {
                        self.categoryItem[staticItem.category.id]?.append(staticItem)
                    }
                }
            }
			
			self.indicatorView.stopAnimating()
			
            self.tableView.reloadData()
        }
        
        let error: (error: ErrorType?, unboxable: ItemError?) -> Void = { (error, unboxable) in
			
			NSLog("HDZItemCategoryTableViewController.getItem")
			NSLog("\(error.debugDescription)")
			
			self.indicatorView.stopAnimating()

            self.request = nil
        }

		// Request
        self.request = HDZApi.item(supplierId, completionBlock: completion, errorBlock: error)

    }
	
	internal func setupFriendInfo(friendInfo: FriendInfo) {
		self.friendInfo = friendInfo
	}
	
	@IBAction func onCloseSelf(sender: AnyObject) {
		self.dismissViewControllerAnimated(true) { 
			
		}
	}
	
	@IBAction func onCheckOrder(sender: AnyObject) {
		
		let controller: HDZItemCheckTableViewController = HDZItemCheckTableViewController.createViewController(self.friendInfo.id)
		self.navigationController?.pushViewController(controller, animated: true)

	}
	
}

