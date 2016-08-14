//
//  HDZCustomerCell.swift
//  seller
//
//  Created by NakaharaShun on 6/20/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZCustomerCell: UITableViewCell {

    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var shopNameLabel: UILabel!
    
    private var friendInfo: FriendInfo! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    
    internal class func dequeueReusableCell(tableView: UITableView, for indexPath: NSIndexPath, friendInfo: FriendInfo) -> HDZCustomerCell {
        let cell: HDZCustomerCell = tableView.dequeueReusableCellWithIdentifier("HDZCustomerCell", forIndexPath: indexPath) as! HDZCustomerCell
        cell.friendInfo = friendInfo
        cell.indexLabel.text = String(format: "%d", indexPath.row + 1)
        cell.shopNameLabel.text = friendInfo.name
        return cell
    }
    
}
