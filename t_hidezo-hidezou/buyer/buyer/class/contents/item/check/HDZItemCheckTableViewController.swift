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
        let button: UIBarButtonItem = UIBarButtonItem(title: "注文する", style: .Done, target: self, action: #selector(HDZItemCheckTableViewController.didSelectedOrder))
        self.navigationItem.setRightBarButtonItem(button, animated: true)
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

        cell.indexText.text = String(format: "%d", indexPath.row + 1)
        
        if let item: HDZOrder = self.result?[indexPath.row] {

            cell.order = item

            let completionHandler: Response<NSData, NSError> -> Void = { (responce: Response<NSData, NSError>) in
                if let value: NSData = responce.result.value {
                    cell.iconImageView.image = UIImage(data: value)
                }
            }
            Alamofire.request(.GET, item.imageURL).responseData(completionHandler: completionHandler)
            
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
            return
        }
        
        let completion: (unboxable: OrderResult?) -> Void = { (unboxable) in
            
        }
        
        let error: (error: ErrorType?, unboxable: OrderError?) -> Void = { (error, unboxable) in
            
        }
        
        HDZApi.order(self.supplierId, deliver_to: "静岡", delivery_day: "明日", charge: "中本", items: items, completionBlock: completion, errorBlock: error)
    }
}

extension HDZItemCheckTableViewController: HDZItemCheckCellDelegate {
    
    func didSelectedDeleted() {
        self.loadItem()
    }
}
