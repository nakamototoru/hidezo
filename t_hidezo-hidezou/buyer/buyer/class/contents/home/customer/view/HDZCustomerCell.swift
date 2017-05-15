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
    @IBOutlet weak var viewBaseBadge: UIView!
	
	var viewBadge:HDZBadgeView! = nil
	
	var friendInfo: FriendInfo! = nil
	var viewController: UIViewController!
	
	var rowOfCell:Int = 0
	var delegate: HDZCustomerCellDelegate?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.orderButton.layer.cornerRadius = 5.0
		
		let myTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZCustomerCell.tapGestureFromLabel))
		self.shopNameLabel .addGestureRecognizer(myTap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func willTransition(to state: UITableViewCellStateMask) {
        super.willTransition(to: state)
    }
    
    override func didTransition(to state: UITableViewCellStateMask) {
        super.didTransition(to: state)
    }
}

// MARK: - Create
extension HDZCustomerCell {
    
    internal class func register(tableView: UITableView) {
        let bundle = Bundle.main
        let nib: UINib = UINib(nibName: "HDZCustomerCell", bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: "HDZCustomerCell")
    }
    
    internal class func dequeueReusableCell(controller: UIViewController, tableView: UITableView, for indexPath: IndexPath, friendInfo: FriendInfo) -> HDZCustomerCell {
        let cell: HDZCustomerCell = tableView.dequeueReusableCell(withIdentifier: "HDZCustomerCell", for: indexPath) as! HDZCustomerCell
        cell.friendInfo = friendInfo
        cell.indexLabel.text = String(format: "%d", indexPath.row + 1)
        cell.shopNameLabel.text = friendInfo.name
        cell.viewController = controller
        return cell
    }
	
	static func getHeight() -> CGFloat {
		
		let views = Bundle.main.loadNibNamed("HDZCustomerCell", owner: self, options: nil)!
		let viewFirst = views.first
		let cell: HDZCustomerCell = viewFirst as! HDZCustomerCell
		let height :CGFloat = cell.frame.size.height
		
		return height;
	}

}

// MARK: - Action
extension HDZCustomerCell {
    
    @IBAction func didSelectedOrder(_ sender: Any) {
		
		// !!!:デザミシステム
		// モーダルで開く
		let controller:HDZItemCategoryNavigationController = HDZItemCategoryNavigationController.createViewController(friendInfo: self.friendInfo)
		self.viewController.navigationController?.present(controller, animated: true, completion: { 
			
		})
		
    }
}

// MARK: - Gesture
extension HDZCustomerCell {
	
	func tapGestureFromLabel(sender:UITapGestureRecognizer){
		delegate?.customercellSelectedRow(row: self.rowOfCell)
	}
}

// MARK: - Badge
extension HDZCustomerCell {
	
	func putBadge(value: Int) {
		
		// !!!バッジビュー
		if self.viewBadge == nil {
            
            self.viewBadge = HDZBadgeView.createWithSize(mysize: self.viewBaseBadge.bounds.size)
            self.viewBaseBadge.addSubview(self.viewBadge)
		}
		self.viewBadge.updateBadge(value: value)
	}

}
