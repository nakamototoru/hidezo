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

        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(HDZCustomerTableViewController.reloadRequest), forControlEvents: .ValueChanged)
        self.refreshControl = refreshControl

        
        HDZCustomerCell.register(self.tableView)
        self.friend()

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 64.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.request?.resume()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.request?.suspend()
    }
    
    deinit {
        self.request?.cancel()
        self.friendList.removeAll()
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
        return cell
    }
	
	// TODO:使わない
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let friendInfo: FriendInfo = self.friendList[indexPath.row]
//        let controller: HDZCustomerDetailTableViewController = HDZCustomerDetailTableViewController.createViewController(friendInfo)
//        self.navigationController?.pushViewController(controller, animated: true)
//    }
	
}

extension HDZCustomerTableViewController : HDZCustomerCellDelegate {

	func customercellSelectedRow(row: Int) {
		// 卸業者の詳細画面へ
		let friendInfo: FriendInfo = self.friendList[row]
		let controller: HDZCustomerDetailTableViewController = HDZCustomerDetailTableViewController.createViewController(friendInfo)
		self.navigationController?.pushViewController(controller, animated: true)
	}
}

// MARK: - private
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
        }
        
        let error: (error: ErrorType?, result: FriendError?) -> Void = { (error, result) in
            
            self.refreshControl?.endRefreshing()
            debugPrint(error)
            debugPrint(result)
        }
        
        self.request = HDZApi.friend(completion, errorBlock: error)
    }
}

extension HDZCustomerTableViewController {
    
    @IBAction func reloadRequest() {
        self.friend()
    }
}

