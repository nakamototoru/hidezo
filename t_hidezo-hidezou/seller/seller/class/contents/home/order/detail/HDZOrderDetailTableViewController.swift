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
    private var orderUpdateRequest: Alamofire.Request? = nil
    private var result: OrderDetailResult! = nil
    
    private var attr_flg: AttrFlg = .other
    private lazy var orderDetailItems: [OrderDetailItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.deleteBackButtonTitle()
        
        self.navigationItem.prompt = self.orderInfo.store_name + "様宛"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "コメント",
                                                                 style: UIBarButtonItemStyle.Done,
                                                                 target: self,
                                                                 action: #selector(HDZOrderDetailTableViewController.didSelectedMessage(_:))
		)
        
        HDZOrderDetailCell.register(self.tableView)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 123.0

        self.orderDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.orderDetailRequest?.resume()
        self.orderUpdateRequest?.resume()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.orderDetailRequest?.suspend()
        self.orderUpdateRequest?.suspend()
    }
    
    deinit {
        self.orderDetailRequest?.cancel()
        self.orderUpdateRequest?.cancel()
    }

}

// MARK: - Table view data source
extension HDZOrderDetailTableViewController {
    
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
//	(in tableView: UITableView) -> Int {
//        return 1
//    }
	
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
            
            debugPrint(result)
            
            self.orderDetailRequest = nil
            

            self.orderDetailItems += result.staicItemList
            self.orderDetailItems += result.dynamicItemList
            self.attr_flg = result.attr_flg
            self.result = result

            self.tableView.tableFooterView = HDZOrderDetailFooter.createView(self, delegate: self, result: result, orderDetailItems: self.orderDetailItems)

            self.tableView.reloadData()
        }
        
        let error: (error: ErrorType?, result: OrderDetailError?) -> Void = { (error, result) in
            debugPrint(error)
            debugPrint(result)
        }
        
        self.orderDetailRequest = HDZApi.orderDitail(self.orderInfo.order_no, completionBlock: completion, errorBlock: error)
    }
    
    private func successUpdate() {
        let action: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (alertaction: UIAlertAction) in
            let _ = self.navigationController?.popViewControllerAnimated( true)
        }
        let controller: UIAlertController = UIAlertController(title: "データーの更新をしました。", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        controller.addAction(action)
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    private func failureUpdate() {
        let action: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        let controller: UIAlertController = UIAlertController(title: "データーの更新に失敗しました。", message: "再度変更するボタンを押すか、一度インターネット環境を確認後やり直してください。", preferredStyle: UIAlertControllerStyle.Alert)
        controller.addAction(action)
        self.presentViewController(controller, animated: true, completion: nil)
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
        return UIModalPresentationStyle.None
    }

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}

// MARK: - OrderDetailItemUpdateDelegate
extension HDZOrderDetailTableViewController: OrderDetailItemUpdateDelegate {
    
    func didSelectedItemUpdate(orderDetailItem: OrderDetailItem!, order_num: String) {
        
        for (index, item) in orderDetailItems.enumerate() {
            
            if item.id == orderDetailItem.id {
                let newItem: OrderDetailItem = OrderDetailItem(orderDetailItem: orderDetailItem, order_num: order_num)
                //orderDetailItems.remove(at: index)
				orderDetailItems.removeAtIndex(index)
                orderDetailItems.insert(newItem, atIndex: index)
                self.tableView.reloadData()
                
                self.tableView.tableFooterView = HDZOrderDetailFooter.createView(self, delegate: self, result: self.result, orderDetailItems: self.orderDetailItems)

                break
            }
        }
    }
}

// MARK: - HDZOrderDetailFooterDelegate
extension HDZOrderDetailTableViewController: HDZOrderDetailFooterDelegate {
    
    func didSelected(param: OrderDetailFooterParam) {
        
        var items: [String] = []
        for item: OrderDetailItem in self.orderDetailItems {
            let value: String = String(format: "%d,%@", item.id, item.order_num)
            items.append(value)
        }
        
        let orderUpdate: OrderUpdate = OrderUpdate(id: HDZUserDefaults.id, uuid: HDZUserDefaults.uuid, order_no: self.result.order_no, items: items, deliver_to: param.deliveredPlace, delivery_day: param.delivered, charge: param.charge)
        self.orderUpdateRequest = HDZApi.orderUpdate(orderUpdate, completionBlock: { (unboxable) in
            self.successUpdate()
            }) { (error, unboxable) in
                
        }
        
    }
}

