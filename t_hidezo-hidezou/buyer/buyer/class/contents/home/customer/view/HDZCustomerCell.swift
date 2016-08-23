//
//  HDZCustomerCell.swift
//  seller
//
//  Created by NakaharaShun on 6/20/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit

protocol HDZCustomerCellDelegate {
	func customercellSelectedRow(row:Int)
}

class HDZCustomerCell: UITableViewCell {

    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    
    private var friendInfo: FriendInfo! = nil
    private var viewController: UIViewController!
	
	var rowOfCell:Int = 0
	var delegate: HDZCustomerCellDelegate?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.orderButton.layer.cornerRadius = 5.0
		
		let myTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZCustomerCell.tapGestureFromLabel(_:)))
		self.shopNameLabel .addGestureRecognizer(myTap)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func willTransitionToState(state: UITableViewCellStateMask) {
        super.willTransitionToState(state)
    }
    
    override func didTransitionToState(state: UITableViewCellStateMask) {
        super.didTransitionToState(state)
    }
}

extension HDZCustomerCell {
    
    internal class func register(tableView: UITableView) {
        let bundle: NSBundle = NSBundle.mainBundle()
        let nib: UINib = UINib(nibName: "HDZCustomerCell", bundle: bundle)
        tableView.registerNib(nib, forCellReuseIdentifier: "HDZCustomerCell")
    }
    
    internal class func dequeueReusableCell(controller: UIViewController, tableView: UITableView, for indexPath: NSIndexPath, friendInfo: FriendInfo) -> HDZCustomerCell {
        let cell: HDZCustomerCell = tableView.dequeueReusableCellWithIdentifier("HDZCustomerCell", forIndexPath: indexPath) as! HDZCustomerCell
        cell.friendInfo = friendInfo
        cell.indexLabel.text = String(format: "%d", indexPath.row + 1)
        cell.shopNameLabel.text = friendInfo.name
        cell.viewController = controller
        return cell
    }
}

extension HDZCustomerCell {
    
    @IBAction func didSelectedOrder(button: UIButton) {
		/*
        let controller: HDZItemCategoryTableViewController = HDZItemCategoryTableViewController.createViewController(self.friendInfo)
		// !!!:デザミシステム
		// タブバーを隠す
		controller.hidesBottomBarWhenPushed = true
        self.viewController.navigationController?.pushViewController(controller, animated: true)
		*/
		
		// !!!:デザミシステム
		// モーダルで開く
		let controller:HDZItemCategoryNavigationController = HDZItemCategoryNavigationController.createViewController(self.friendInfo)
		self.viewController.navigationController?.presentViewController(controller, animated: true, completion: { 
			
		})
		
    }
}

extension HDZCustomerCell {
	
	func tapGestureFromLabel(sender:UITapGestureRecognizer){
		delegate?.customercellSelectedRow(self.rowOfCell)
	}

}