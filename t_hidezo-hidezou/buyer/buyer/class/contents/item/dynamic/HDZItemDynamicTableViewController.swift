//
//  HDZItemDynamicTableViewController.swift
//  buyer
//
//  Created by NakaharaShun on 17/07/2016.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZItemDynamicTableViewController: UITableViewController {
    
    private var dynamicItemInfo: DynamicItemInfo!
    private var dynamicItem: [DynamicItem] = []
    private var attr_flg: AttrFlg = .other
    private var supplierId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HDZItemDynamicCell.register(self.tableView)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.tableHeaderView = HDZItemDinamicHeaderView.createView(self.dynamicItemInfo)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HDZItemDynamicTableViewController {
    
    internal class func createViewController(dynamicItemInfo: DynamicItemInfo, dynamicItem: [DynamicItem], attr_flg: AttrFlg, supplierId: Int) -> HDZItemDynamicTableViewController {
        let controller: HDZItemDynamicTableViewController = UIViewController.createViewController("HDZItemDynamicTableViewController")
        controller.dynamicItem = dynamicItem
        controller.dynamicItemInfo = dynamicItemInfo
        controller.attr_flg = attr_flg
        controller.supplierId = supplierId
        return controller
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
        
        var isInt: Bool = true
        for numScale: String in item.num_scale {
            if let _: Int = Int(numScale) {
                
            } else {
                isInt = false
            }
        }
        
        debugPrint(item.id)
        
        if isInt {
            let cell: HDZItemDynamicCell = HDZItemDynamicCell.dequeueReusableCell(tableView, forIndexPath: indexPath, dynamicItem: item, attr_flg: self.attr_flg, supplierId: self.supplierId)
            cell.indexLabel.text = String(format: "%d", indexPath.row + 1)
            cell.itemName.text = item.item_name
            cell.priceLabel.text = item.price
            
            if let item: HDZOrder = try! HDZOrder.queries(supplierId, itemId: item.id, dynamic: true) {
                cell.count = item.size
            }

            return cell
        } else {
            let cell: HDZItemDynamicCell = HDZItemDynamicCell.dequeueReusableCell(tableView, forIndexPath: indexPath, dynamicItem: item, attr_flg: self.attr_flg, supplierId: self.supplierId)
            cell.indexLabel.text = String(format: "%d", indexPath.row + 1)
            cell.itemName.text = item.item_name
            cell.priceLabel.text = item.price
            
            if let item: HDZOrder = try! HDZOrder.queries(supplierId, itemId: item.id, dynamic: true) {
                cell.count = item.size
            }

            return cell
        }
    }
}
