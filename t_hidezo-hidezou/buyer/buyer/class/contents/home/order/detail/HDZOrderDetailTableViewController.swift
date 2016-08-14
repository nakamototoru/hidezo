//
//  HDZOrderDetailTableViewController.swift
//  seller
//
//  Created by NakaharaShun on 6/21/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire

class HDZOrderDetailTableViewController: UITableViewController {

    private var orderInfo: OrderInfo! = nil
    private var orderDetailRequest: Alamofire.Request? = nil
    
    private var attr_flg: AttrFlg = .other
    private lazy var orderDetailItems: [OrderDetailItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.deleteBackButtonTitle()
        
        self.navigationItem.prompt = self.orderInfo.supplier_name + "様宛"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "コメント", style: .Done, target: self, action: #selector(HDZOrderDetailTableViewController.didSelectedMessage(_:)))
        
        HDZOrderDetailCell.register(self.tableView)
        
        self.tableView.tableFooterView = HDZOrderDetailFooter.createView()

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 113.0

        self.orderDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.orderDetailRequest?.resume()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.orderDetailRequest?.suspend()
    }
    
    deinit {
        self.orderDetailRequest?.cancel()
    }

}

// MARK: - Table view data source
extension HDZOrderDetailTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.orderDetailItems.count
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let orderDetailItem: OrderDetailItem = self.orderDetailItems[indexPath.row]
        let cell = HDZOrderDetailCell.dequeueReusableCell(self, tableView: tableView, for: indexPath, orderDetailItem: orderDetailItem, attr_flg: self.attr_flg)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let orderDetailItem: OrderDetailItem = self.orderDetailItems[indexPath.row]
        let controller: HDZOrderItemTableViewController = HDZOrderItemTableViewController.createViewController(orderDetailItem)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - static
extension HDZOrderDetailTableViewController {
    
    internal class func createViewController(orderInfo: OrderInfo) -> HDZOrderDetailTableViewController {
        let controller: HDZOrderDetailTableViewController = UIViewController.createViewController("HDZOrderDetailTableViewController")
        controller.orderInfo = orderInfo
        return controller
    }
}

// MARK: - private
extension HDZOrderDetailTableViewController {
    
    private func orderDetail() {
        
        let completion: (unboxable: OrderDetailResult?) -> Void = { (unboxable) in
            guard let result: OrderDetailResult = unboxable else {
                return
            }
            
            self.orderDetailRequest = nil
            
            self.orderDetailItems += result.staicItemList
            self.orderDetailItems += result.dynamicItemList
            self.attr_flg = result.attr_flg
            
            self.tableView.reloadData()
        }
        
        let error: (error: ErrorType?, result: OrderDetailError?) -> Void = { (error, result) in
            
        }
        
        self.orderDetailRequest = HDZApi.orderDitail(self.orderInfo.order_no, completionBlock: completion, errorBlock: error)
    }
}

// MARK: - action
extension HDZOrderDetailTableViewController {
    
    @IBAction func didSelectedMessage(button: UIBarButtonItem) {
        let controller: HDZCommentTableViewController = HDZCommentTableViewController.createViewController(self.orderInfo)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UIPopoverPresentationControllerDelegate
extension HDZOrderDetailTableViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .None
    }
}
