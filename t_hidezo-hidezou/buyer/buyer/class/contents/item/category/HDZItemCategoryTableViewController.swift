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

    private let dynamicTitle: String = "動的商品"
    private var categoryName: [Int : String] = [:]
    private var categoryItem: [Int: [StaticItem]] = [:]
    
    private var friendInfo: FriendInfo! = nil
    private var itemResult: ItemResult! = nil
    private var request: Alamofire.Request? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getItem(self.friendInfo.id)
        
        self.title = self.friendInfo.name
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.request?.suspend()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if try! HDZOrder.queries(self.friendInfo.id).count > 0 {
            self.tableView.tableFooterView = HDZItemCheckOrderFooter.createView(self, supplierId: self.friendInfo.id)
        }

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
            if self.itemResult == nil || self.itemResult.dynamicItem.count <= 0 {
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
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("itemCategoryCell", forIndexPath: indexPath)
            
            cell.textLabel?.text = self.dynamicTitle
            
            return cell
        default:
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("itemCategoryCell", forIndexPath: indexPath)
            
            if let keys: [Int] = self.categoryName.keys.sort() {
                cell.textLabel?.text = self.categoryName[keys[indexPath.row]]
            }
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            let controller: HDZItemDynamicTableViewController = HDZItemDynamicTableViewController.createViewController(self.itemResult.dynamicItemInfo, dynamicItem: self.itemResult.dynamicItem, attr_flg: self.itemResult.attr_flg, supplierId: self.itemResult.supplier.supplier_id)
            self.navigationController?.pushViewController(controller, animated: true)
            break
        case 1:
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

extension HDZItemCategoryTableViewController {
    
    private func getItem(supplierId: Int) {
        
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
            
            if try! HDZOrder.queries(self.friendInfo.id).count > 0 {
                self.tableView.tableFooterView = HDZItemCheckOrderFooter.createView(self, supplierId: self.friendInfo.id)
            }
            
            self.tableView.reloadData()
        }
        
        let error: (error: ErrorType?, unboxable: ItemError?) -> Void = { (error, unboxable) in
            
            self.request = nil
        }
        
        self.request = HDZApi.item(supplierId, completionBlock: completion, errorBlock: error)
    }
}

