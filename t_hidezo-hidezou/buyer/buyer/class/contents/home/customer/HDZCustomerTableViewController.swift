//
//  HDZCustomerTableViewController.swift
//  seller
//
//  Created by NakaharaShun on 6/20/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire

class HDZCustomerTableViewController: UITableViewController {

    private lazy var friendList: [FriendInfo] = []
    private var request: Alamofire.Request? = nil
	
    override func viewDidLoad() {
        super.viewDidLoad()

        self.deleteBackButtonTitle()

		// ナビゲーション右ボタン
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "ログアウト", style: .Done, target: self, action: #selector(didSelectedLogout(_:)))
		
		// 再読込イベント
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadRequest), forControlEvents: .ValueChanged)
        self.refreshControl = refreshControl

        
        HDZCustomerCell.register(self.tableView)
        self.friend()

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 64.0
		
		// !!!:バッジ通知
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(getNotification(_:)), name: HDZPushNotificationManager.shared.strNotificationSupplier, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
//	override func viewWillAppear(animated: Bool) {
//		super.viewWillAppear(animated)
//		
//	}
	
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
		
		self.tableView.reloadData()
		
        self.request?.resume()
		
		// バッジ表示
		HDZPushNotificationManager.updateSupplierBadge(self)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.request?.suspend()		
    }
    
    deinit {
        self.request?.cancel()
        self.friendList.removeAll()
		
		//イベントリスナーの削除
		NSNotificationCenter.defaultCenter().removeObserver(self)
    }

	// 再読込
	func reloadRequest() {
		self.friend()
	}

	// !!!:通知受け取り時
	func getNotification(notification: NSNotification)  {
		
		self.tableView.reloadData()
		
		// バッジ表示
		HDZPushNotificationManager.updateSupplierBadge(self)
	}
	
	// !!!:ログアウト
	func didSelectedLogout(sender: UIBarButtonItem) {

		// ログアウト確認
		let handler: (UIAlertAction) -> Void = { (alertAction: UIAlertAction) in
			
			DeployGateExtra.DGSLog("ログアウト：" + HDZUserDefaults.id)

			// ログアウト実行
//			HDZUserDefaults.login = false
			HDZApi.logOut({ (unboxable) in
				
//				let controller: HDZTopViewController = HDZTopViewController.createViewController()
//				UIApplication.setRootViewController(controller)
//				let navigationController: UINavigationController = HDZLoginViewController.createViewController()
//				self.presentViewController(navigationController, animated: true, completion: {
//					self.tabBarController?.selectedIndex = 0
//				})

				}, errorBlock: { (error, unboxable) in
					
//					let controller: HDZTopViewController = HDZTopViewController.createViewController()
//					UIApplication.setRootViewController(controller)
//					let navigationController: UINavigationController = HDZLoginViewController.createViewController()
//					self.presentViewController(navigationController, animated: true, completion: {
//						self.tabBarController?.selectedIndex = 0
//					})
			})

			// TODO:カートを空に
			
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

}

// MARK: - API
extension HDZCustomerTableViewController {
	
	private func friend() {
		
		self.refreshControl?.beginRefreshing()
		
		let completion: (unboxable: FriendResult?) -> Void = { (unboxable) in
			
			self.refreshControl?.endRefreshing()
			
			guard let result: FriendResult = unboxable else {
				return
			}
			
			self.request = nil
			
			self.friendList = result.friendList
			
			self.tableView.reloadData()
			
			// !!!:バッジチェック
			HDZPushNotificationManager.checkBadge()
		}
		
		let error: (error: ErrorType?, result: FriendError?) -> Void = { (error, result) in
			
			self.refreshControl?.endRefreshing()
			#if DEBUG
			debugPrint(error)
			debugPrint(result)
			#endif
		}
		
		self.request = HDZApi.friend(completion, errorBlock: error)
	}
}

// MARK: - Table view data source
extension HDZCustomerTableViewController {
	
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
        let friendInfo: FriendInfo = self.friendList[indexPath.row]
        let cell: HDZCustomerCell = HDZCustomerCell.dequeueReusableCell(self, tableView: tableView, for: indexPath, friendInfo: friendInfo)
		cell.delegate = self
		cell.rowOfCell = indexPath.row
//		cell.contentView.autoresizingMask = UIViewAutoresizing.FlexibleHeight|UIViewAutoresizing.FlexibleWidth
		
        return cell
    }

	override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		
		let customcell:HDZCustomerCell = cell as! HDZCustomerCell
		
		// !!!:バッジ表示判定
		guard let friendInfo: FriendInfo = self.friendList[indexPath.row] else {
			return
		}
		let list:[SupplierId] = HDZPushNotificationManager.shared.getSupplierUpList()
		var badgeValue:Int = 0
		for obj:SupplierId in list {
			let id:String = obj.supplierId
			if id == friendInfo.id {
				// !!!:バッジ表示
				badgeValue = 1
				break
			}
		}
		customcell.putBadge( badgeValue )

	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		return HDZCustomerCell.getHeight()
	}
}

// MARK: - HDZCustomerCellDelegate
extension HDZCustomerTableViewController : HDZCustomerCellDelegate {

	func customercellSelectedRow(row: Int) {
		// 卸業者の詳細画面へ
		let friendInfo: FriendInfo = self.friendList[row]
		let controller: HDZCustomerDetailTableViewController = HDZCustomerDetailTableViewController.createViewController(friendInfo)
		self.navigationController?.pushViewController(controller, animated: true)
	}
}
