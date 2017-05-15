//
//  HDZCustomerDetailViewController.swift
//  seller
//
//  Created by NakaharaShun on 6/20/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZCustomerDetailTableViewController: UITableViewController {

	@IBOutlet weak var shopnameCell: UITableViewCell!
    @IBOutlet weak var addressCell: UITableViewCell!
    @IBOutlet weak var emailCell: UITableViewCell!
    @IBOutlet weak var mobileCell: UITableViewCell!
    @IBOutlet weak var telCell: UITableViewCell!
    @IBOutlet weak var ownerCell: UITableViewCell!
    
	var friendInfo: FriendInfo! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.friendInfo.name
        self.addressCell.textLabel?.text = self.friendInfo.address
        self.emailCell.textLabel?.text = self.friendInfo.mail_addr
        self.mobileCell.textLabel?.text = self.friendInfo.mobile
        self.telCell.textLabel?.text = self.friendInfo.tel
        self.ownerCell.textLabel?.text = self.friendInfo.minister
		
		// !!!:デザミ
		self.shopnameCell.textLabel?.text = self.friendInfo.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HDZCustomerDetailTableViewController {
    
    internal class func createViewController(friendInfo: FriendInfo) -> HDZCustomerDetailTableViewController {
        let controller: HDZCustomerDetailTableViewController = UIViewController.createViewController(name: "HDZCustomerDetailTableViewController")
        controller.friendInfo = friendInfo
        return controller
    }
}
