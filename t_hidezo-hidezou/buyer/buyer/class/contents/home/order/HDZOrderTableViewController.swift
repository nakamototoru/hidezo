//
//  HDZOrderTableViewController.swift
//  seller
//
//  Created by NakaharaShun on 6/20/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire

class HDZOrderTableViewController: UITableViewController {

    private lazy var orderList: [OrderInfo] = []
    private var request: Alamofire.Request? = nil
    private var page: Int = 0
    
    private var stopLoading: Bool = false
	
	// !!!: dezami
	private var indicatorView:CustomIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

		// ナビゲーションバー
        self.deleteBackButtonTitle()

		// テーブルセル
        HDZOrderCell.register(self.tableView)
		
		// 再読み込みイベント
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(HDZOrderTableViewController.reloadRequest), forControlEvents: .ValueChanged)
        self.refreshControl = refreshControl
		
		//インジケータ
		self.indicatorView = CustomIndicatorView.createView(self.view.frame.size)
		self.view.addSubview(self.indicatorView)
		
		// !!!:バッジ通知
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HDZOrderTableViewController.getNotification(_:)), name: HDZPushNotificationManager.shared.strNotificationMessage, object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidDisappear(animated)
    
        self.request?.resume()
        
        self.reloadRequest()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.request?.suspend()
    }
    
    deinit {
        self.request?.cancel()
		
		//イベントリスナーの削除
		NSNotificationCenter.defaultCenter().removeObserver(self)
    }
	
	// !!!:通知受け取り時
	func getNotification(notification: NSNotification)  {
		
		self.tableView.reloadData()
	}

}

// MARK: - Tableview datasource
extension HDZOrderTableViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if !self.stopLoading && self.orderList.count <= indexPath.row + 1 {
            self.orderList(false)
        }
        
        let cell: HDZOrderCell = HDZOrderCell.dequeueReusableCell(tableView, for: indexPath, orderInfo: self.orderList[indexPath.row])
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let orderIndo: OrderInfo = self.orderList[indexPath.row]
        let controller: HDZOrderDetailTableViewController = HDZOrderDetailTableViewController.createViewController(orderIndo)
		
		// !!!:デザミシステム
		//controller.view.layoutIfNeeded()
		
        self.navigationController?.pushViewController(controller, animated: true) // true
    }
	
	
	override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		
		let customcell:HDZOrderCell = cell as! HDZOrderCell
		
		guard let order:OrderInfo = self.orderList[indexPath.row] else {
			return
		}
		
		// !!!:バッジ表示判定
		let list:[MessageUp] = HDZPushNotificationManager.shared.getMessageUpList()
		var badgeValue:Int = 0
		for obj:MessageUp in list {
			let order_no:String = obj.order_no
			if order_no == order.order_no {
				badgeValue = Int( obj.messageCount )!
				break
			}
		}
		// !!!:バッジ表示
		customcell.putBadge( badgeValue )
		
	}
}

extension HDZOrderTableViewController {
    
    @IBAction func reloadRequest() {
        self.page = 0
        self.stopLoading = false
        self.orderList(true)
    }
}

extension HDZOrderTableViewController {
    
    private func orderList(reset: Bool) {
		
		// インジケータ
		self.indicatorView.startAnimating()

        self.refreshControl?.beginRefreshing()

        if self.stopLoading {
            self.refreshControl?.endRefreshing()
            self.request = nil
			
			//インジケータ
			self.indicatorView.stopAnimating()
			
            return
        }
        
        self.page += 1
        
        let completion: (unboxable: OrderListResult?) -> Void = { (unboxable) in
            
            self.refreshControl?.endRefreshing()
            guard let result: OrderListResult = unboxable else {
                return
            }
            
            self.request = nil
            
            if reset {
                self.orderList.removeAll()
            }
            
            if result.orderList.count <= 0 {
                self.stopLoading = true
                self.page -= 1
                return
            }
            
            self.orderList += result.orderList
			
			//インジケータ
			self.indicatorView.stopAnimating()
			
            self.tableView.reloadData()
        }
        
        let error: (error: ErrorType?, result: OrderListError?) -> Void = { (error, result) in
            self.refreshControl?.endRefreshing()
            //self.page -= 1
			
			//インジケータ
			self.indicatorView.stopAnimating()

			#if DEBUG
				let action: UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: { (alert:UIAlertAction) in
					
				})
				let controller: UIAlertController = UIAlertController(title: "ERROR", message: error.debugDescription, preferredStyle: .Alert)
				controller.addAction(action)
				self.presentViewController(controller, animated: true, completion: nil)
			#endif
        }

		// Request
        self.request = HDZApi.orderList(page, completionBlock: completion, errorBlock: error)
		
    }
}
