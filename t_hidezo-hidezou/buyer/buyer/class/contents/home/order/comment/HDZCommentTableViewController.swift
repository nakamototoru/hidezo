//
//  HDZCommentTableViewController.swift
//  seller
//
//  Created by NakaharaShun on 6/22/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire

class HDZCommentTableViewController: UITableViewController {

    private var orderInfo: OrderInfo! = nil
    private var messageResult: MessageResult! = nil
    private lazy var messageList: [MessageInfo] = []
    
    private var request: Alamofire.Request? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.navigationItem.prompt = self.orderInfo.supplier_name + "様宛"
		self.title = self.orderInfo.supplier_name + "様宛"
		
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: #selector(didSelectedCommentCreate(_:)))
        
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadRequest), forControlEvents: .ValueChanged)
        self.refreshControl = refreshControl
        
        HDZCommentCell.register(self.tableView)
        
//        self.tableView.rowHeight = UITableViewAutomaticDimension
//        self.tableView.estimatedRowHeight = 95.0
		
        self.requestMessage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.request?.resume()
		
		// バッジ更新
		HDZPushNotificationManager.updateMessageBadgeWithController(self)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.request?.suspend()
    }
    
    deinit {
        self.request?.cancel()
    }
	
	func didSelectedCommentCreate(barButtonItem: UIBarButtonItem) {
		
		let controller: HDZCommentCreateViewController = HDZCommentCreateViewController.createViewController(self, messageResult: self.messageResult, order_no: self.orderInfo.order_no)
		self.presentViewController(controller, animated: true, completion: nil)
	}

	func reloadRequest() {
		self.requestMessage()
	}

}

// MARK: - Table view data source
extension HDZCommentTableViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let messageInfo: MessageInfo = self.messageList[indexPath.row]
        let cell = HDZCommentCell.dequeueReusable(tableView, indexPath: indexPath, messageInfo: messageInfo, maxIndex: self.messageList.count)
		cell.parent = self
        return cell
     }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(format: "%d件のコメントがあります。", self.messageList.count)
    }
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		return HDZCommentCell.getHeight()
	}
}

// MARK: - static
extension HDZCommentTableViewController {
    
    internal class func createViewController(orderInfo: OrderInfo) -> HDZCommentTableViewController {
        let controller: HDZCommentTableViewController = UIViewController.createViewController("HDZCommentTableViewController")
        controller.orderInfo = orderInfo
        return controller
    }
}

// MARK: - UIPopoverPresentationControllerDelegate
extension HDZCommentTableViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .None
    }
}

extension HDZCommentTableViewController: HDZCommentCreateViewControllerDelegate {
    func requestUpdate() {
        self.requestMessage()
    }
}

// MARK: - action
//extension HDZCommentTableViewController {
//    
////    @IBAction func didSelectedCommentCreate(barButtonItem: UIBarButtonItem) {
////		
////        let controller: HDZCommentCreateViewController = HDZCommentCreateViewController.createViewController(self, messageResult: self.messageResult, order_no: self.orderInfo.order_no)
////        self.presentViewController(controller, animated: true, completion: nil)
////    }
//	
////    @IBAction func reloadRequest() {
////        self.requestMessage()
////    }
//}

// MARK: - api
extension HDZCommentTableViewController {
    
    private func requestMessage() {
        
        self.refreshControl?.beginRefreshing()
        
        let completion: (unboxable: MessageResult?) -> Void = { (unboxable) in
        
            self.refreshControl?.endRefreshing()
            
            guard let result: MessageResult = unboxable else {
                return
            }
            
            self.request = nil
            
            self.messageResult = result
            self.messageList = result.messageList.reverse()
            
            self.tableView.reloadData()
			
			// !!!:dezami・バッジ消去
			HDZPushNotificationManager.shared.removeMessageUp(self.orderInfo.order_no)
//			let messageList:[MessageUp] = HDZPushNotificationManager.shared.getMessageUpList()
//			if messageList.count > 0 {
//				self.tabBarController?.tabBar.items![1].badgeValue = String(messageList.count) // 下階層から呼ぶ場合
//			}
//			else {
//				self.tabBarController?.tabBar.items![1].badgeValue = nil // 下階層から呼ぶ場合
//			}
			HDZPushNotificationManager.updateMessageBadgeWithController(self)
        }
        
        let error: (error: ErrorType?, result: MessageError?) -> Void = { (error, unboxable) in
            self.refreshControl?.endRefreshing()
        }
        
        self.request = HDZApi.message(self.orderInfo.order_no, completionBlock: completion, errorBlock: error)
    }
}
