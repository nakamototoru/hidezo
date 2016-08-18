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
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let image: UIImage? = UIImage(named: "order_blue")?.imageWithRenderingMode(.AlwaysOriginal)
//        let selectedImage: UIImage? = UIImage(named: "order_white")?.imageWithRenderingMode(.AlwaysOriginal)
		
//        self.tabBarItem = UITabBarItem(title: "注文", image: image, selectedImage: selectedImage)
        self.deleteBackButtonTitle()
        
        HDZOrderCell.register(self.tableView)
        
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(HDZOrderTableViewController.reloadRequest), forControlEvents: .ValueChanged)
        self.refreshControl = refreshControl

        self.orderList(true)
		
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
    }
}

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
		controller.view.layoutIfNeeded()
		
        self.navigationController?.pushViewController(controller, animated: false) // true
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
        
        self.refreshControl?.beginRefreshing()

        if self.stopLoading {
            self.refreshControl?.endRefreshing()
            self.request = nil
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
            
            self.tableView.reloadData()
        }
        
        let error: (error: ErrorType?, result: OrderListError?) -> Void = { (error, result) in
            self.refreshControl?.endRefreshing()
            self.page -= 1
        }
        
        self.request = HDZApi.orderList(page, completionBlock: completion, errorBlock: error)
    }
}
