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

	lazy var orderList: [OrderInfo] = []
	var request: Alamofire.Request? = nil
	var pageOfRead: Int = 1
    
	var isLoading: Bool = false
	
	// !!!: dezami
	var indicatorView:CustomIndicatorView!
	
	var scrollBeginingPoint: CGPoint = CGPoint.zero

	
    override func viewDidLoad() {
        super.viewDidLoad()

		// ナビゲーションバー
        self.deleteBackButtonTitle()

		// ナビゲーション右ボタン
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "ログアウト", style: .done, target: self, action: #selector(didSelectedLogout))

		// テーブルセル
        HDZOrderCell.register(tableView: self.tableView)
		
		// 再読み込みイベント
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(HDZOrderTableViewController.reloadRequest), for: .valueChanged)
        self.refreshControl = refreshControl
		
		//インジケータ
		self.indicatorView = CustomIndicatorView.createView(framesize: self.view.frame.size)
		self.view.addSubview(self.indicatorView)
		
		// !!!:バッジ通知
		NotificationCenter.default.addObserver(self, selector: #selector(getNotification), name: HDZPushNotificationManager.shared.strNotificationMessage, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    
        self.request?.resume()
        
        self.reloadRequest()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.request?.suspend()
    }
    
    deinit {
        self.request?.cancel()
		
		//イベントリスナーの削除
		NotificationCenter.default.removeObserver(self)
    }
	
	// !!!:通知受け取り時
	func getNotification(notification: NSNotification)  {
		
		self.tableView.reloadData()
	}

	// !!!:ログアウト
	func didSelectedLogout(sender: UIBarButtonItem) {
		
		// ログアウト確認
		let handler: (UIAlertAction) -> Void = { (alertAction: UIAlertAction) in
			// ログアウト実行
			let _ = HDZApi.logOut(completionBlock: { (unboxable) in
				}, errorBlock: { (error, unboxable) in
			})

			DeployGateExtra.dgsLog("ログアウト：" + HDZUserDefaults.id)
			
			let controller: HDZTopViewController = HDZTopViewController.createViewController()
			UIApplication.setRootViewController(viewController: controller)
			
			let navigationController: UINavigationController = HDZLoginViewController.createViewController()
			self.present(navigationController, animated: true, completion: {
				self.tabBarController?.selectedIndex = 0
			})
		}
		
		let action: UIAlertAction = UIAlertAction(title: "OK", style: .destructive, handler: handler)
		let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		let controller: UIAlertController = UIAlertController(title: "ログアウトしますか？", message: "別のアカウントや現在のアカウントで再ログインすることができます。", preferredStyle: .alert)
		controller.addAction(action)
		controller.addAction(cancel)
		
		self.present(controller, animated: true, completion: nil)
	}

	// MARK: - UIScrollViewDelegate
	// スクロール開始
//	override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//		super.scrollViewWillBeginDragging(scrollView)
//		
//		scrollBeginingPoint = scrollView.contentOffset;
//	}
//	
//	override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//		let currentPoint = scrollView.contentOffset;
//		if scrollBeginingPoint.y < currentPoint.y {
//			// debugPrint("下へスクロール")
//			let contentOffsetY = currentPoint.y //self.tableView.contentOffset.y
//			let boundsSizeHeight = scrollView.bounds.size.height
//			let contentOffsetWidthWindow = contentOffsetY + boundsSizeHeight
//			let contentSizeHeight = scrollView.contentSize.height
//			if contentOffsetWidthWindow > contentSizeHeight {
//				if !self.isLoading {
//					self.isLoading = true
//					//　ページ継続読込
//					self.getOrderList(reset: false)
//				}
//			}
//		}
//	}

}

// MARK: - Tableview datasource
extension HDZOrderTableViewController {

//	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.orderList.count
//    }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.orderList.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: HDZOrderCell = HDZOrderCell.dequeueReusableCell(tableView: tableView, for: indexPath, orderInfo: self.orderList[indexPath.row])
        return cell
    }

//	override func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
//        let orderIndo: OrderInfo = self.orderList[indexPath.row]
//        let controller: HDZOrderDetailTableViewController = HDZOrderDetailTableViewController.createViewController(orderInfo: orderIndo)
//				
//        self.navigationController?.pushViewController(controller, animated: true) // true
//    }
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let orderIndo: OrderInfo = self.orderList[indexPath.row]
		let controller: HDZOrderDetailTableViewController = HDZOrderDetailTableViewController.createViewController(orderInfo: orderIndo)
		
		self.navigationController?.pushViewController(controller, animated: true) // true
	}
	
//	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//		
//		let customcell:HDZOrderCell = cell as! HDZOrderCell
//		
//		let order:OrderInfo = self.orderList[indexPath.row]
//		
//		// !!!:バッジ表示判定
//		let list:[MessageUp] = HDZPushNotificationManager.shared.getMessageUpList()
//		var badgeValue:Int = 0
//		for obj:MessageUp in list {
//			let order_no:String = obj.order_no
//			if order_no == order.order_no {
//				badgeValue = obj.messageCount
//				break
//			}
//		}
//		// !!!:バッジ表示
//		customcell.putBadge( value: badgeValue )
//	}
	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let customcell:HDZOrderCell = cell as! HDZOrderCell
		
		let order:OrderInfo = self.orderList[indexPath.row]
		
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
		customcell.putBadge( value: badgeValue )
	}
}

// MARK: - API
extension HDZOrderTableViewController {
    
    func reloadRequest() {
        self.pageOfRead = 1
		self.isLoading = true
        self.getOrderList(reset: true)
    }
}

extension HDZOrderTableViewController {
    
	func getOrderList(reset: Bool) {
		
		// インジケータ
		self.indicatorView.startAnimating()

        self.refreshControl?.beginRefreshing()
		
        let completion: (_ unboxable: OrderListResult?) -> Void = { (unboxable) in
			
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
                return
            }
            
            self.orderList += result.orderList
			
			//インジケータ
			self.indicatorView.stopAnimating()
			
            self.tableView.reloadData()
			
			self.pageOfRead += 1
        }
        
        let error: (_ error: Error?, _ result: OrderListError?) -> Void = { (error, result) in
			
			self.isLoading = false

            self.refreshControl?.endRefreshing()
			
			//インジケータ
			self.indicatorView.stopAnimating()

			#if DEBUG
				debugPrint(error.debugDescription)
				// エラーダイアログ
				let action: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: { (alert:UIAlertAction) in
				})
				let controller: UIAlertController = UIAlertController(title: "ERROR", message: error.debugDescription, preferredStyle: .alert)
				controller.addAction(action)
				self.present(controller, animated: true, completion: nil)
			#endif
        }

		// Request
        self.request = HDZApi.orderList(page: self.pageOfRead, completionBlock: completion, errorBlock: error)
		
    }
}
