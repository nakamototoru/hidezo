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
    
//    private var stopLoading: Bool = false
	var isLoading: Bool = false
	
	// !!!: dezami
	private var indicatorView:CustomIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

		// ナビゲーションバー
        self.deleteBackButtonTitle()

		// ナビゲーション右ボタン
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "ログアウト", style: .Done, target: self, action: #selector(didSelectedLogout(_:)))

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
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(getNotification(_:)), name: HDZPushNotificationManager.shared.strNotificationMessage, object: nil)
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
		
		// バッジ更新
//		HDZPushNotificationManager.updateMessageBadgeWithController(self)
	}

	// !!!:ログアウト実行
	func didSelectedLogout(sender: UIBarButtonItem) {
		
		// ログアウト実行
		let handler: (UIAlertAction) -> Void = { (alertAction: UIAlertAction) in
			HDZUserDefaults.login = false
			//            HDZUserDefaults.id = 0
			
			let controller: HDZTopViewController = HDZTopViewController.createViewController()
			UIApplication.setRootViewController(controller)
			
			let navigationController: UINavigationController = HDZLoginViewController.createViewController()
			self.presentViewController(navigationController, animated: true, completion: {
				self.tabBarController?.selectedIndex = 0
			})
		}
		
		let action: UIAlertAction = UIAlertAction(title: "OK", style: .Destructive, handler: handler)
		let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
		
		let controller: UIAlertController = UIAlertController(title: "ログアウトしますか？", message: "別のアカウントや現在のアカウントで再ログインすることができます。", preferredStyle: .Alert)
		controller.addAction(action)
		controller.addAction(cancel)
		
		self.presentViewController(controller, animated: true, completion: nil)
	}

	// 1番したまでスクロールしたらデータ取得
	override func scrollViewDidScroll(scrollView: UIScrollView)
	{
		let contentOffsetWidthWindow = self.tableView.contentOffset.y + self.tableView.bounds.size.height
		let eachToBottom = contentOffsetWidthWindow >= self.tableView.contentSize.height
		if (!eachToBottom || self.isLoading) {
			return;
		}
		
		self.isLoading = true
		
		//　ページ継続読込
		self.getOrderList(false)		
	}
}

// MARK: - Tableview datasource
extension HDZOrderTableViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		// テーブル更新の判定
//        if !self.stopLoading && self.orderList.count <= indexPath.row + 1 {
//			//　ページ継続読込
//            self.getOrderList(false)
//        }
		
        let cell: HDZOrderCell = HDZOrderCell.dequeueReusableCell(tableView, for: indexPath, orderInfo: self.orderList[indexPath.row])
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let orderIndo: OrderInfo = self.orderList[indexPath.row]
        let controller: HDZOrderDetailTableViewController = HDZOrderDetailTableViewController.createViewController(orderIndo)
				
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
				badgeValue = obj.messageCount
				break
			}
		}
		// !!!:バッジ表示
		customcell.putBadge( badgeValue )
		
	}
}

// MARK: - API
extension HDZOrderTableViewController {
    
    func reloadRequest() {
        self.page = 0
//        self.stopLoading = false
		self.isLoading = true
        self.getOrderList(true)
    }
}

extension HDZOrderTableViewController {
    
    private func getOrderList(reset: Bool) {
		
		// インジケータ
		self.indicatorView.startAnimating()

        self.refreshControl?.beginRefreshing()

//        if self.stopLoading {
//            self.refreshControl?.endRefreshing()
//            self.request = nil
//			
//			//インジケータ
//			self.indicatorView.stopAnimating()
//			
//            return
//        }
		
//        self.page += 1
		
        let completion: (unboxable: OrderListResult?) -> Void = { (unboxable) in
			
			self.isLoading = false

            self.refreshControl?.endRefreshing()
            guard let result: OrderListResult = unboxable else {
                return
            }
            
            self.request = nil
            
            if reset {
                self.orderList.removeAll()
            }
            
            if result.orderList.count == 0 {
//                self.stopLoading = true
				
                return
            }
            
            self.orderList += result.orderList
			
			//インジケータ
			self.indicatorView.stopAnimating()
			
            self.tableView.reloadData()
			
			self.page += 1
			
			// バッジ更新
//			HDZPushNotificationManager.updateMessageBadgeWithController(self)
        }
        
        let error: (error: ErrorType?, result: OrderListError?) -> Void = { (error, result) in
			
			self.isLoading = false

            self.refreshControl?.endRefreshing()
			
			//インジケータ
			self.indicatorView.stopAnimating()

			#if DEBUG
				debugPrint(error.debugDescription)
				// エラーダイアログ
				let action: UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: { (alert:UIAlertAction) in
				})
				let controller: UIAlertController = UIAlertController(title: "ERROR", message: error.debugDescription, preferredStyle: .Alert)
				controller.addAction(action)
				self.presentViewController(controller, animated: true, completion: nil)
			#endif
        }

		// Request
        self.request = HDZApi.orderList(self.page, completionBlock: completion, errorBlock: error)
		
    }
}
