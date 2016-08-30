//
//  HDZItemCategoryTableViewCell.swift
//  buyer
//
//  Created by デザミ on 2016/08/18.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZItemCategoryTableViewCell: UITableViewCell {

	@IBOutlet weak var labelName: UILabel!
	
	var viewBadge:HDZBadgeView! = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension HDZItemCategoryTableViewCell {
	
	internal class func register(tableView: UITableView) {
		let bundle: NSBundle = NSBundle.mainBundle()
		let nib: UINib = UINib(nibName: "HDZItemCategoryTableViewCell", bundle: bundle)
		tableView.registerNib(nib, forCellReuseIdentifier: "HDZItemCategoryTableViewCell")
	}

	internal class func dequeueReusableCell(tableView: UITableView, forIndexPath indexPath: NSIndexPath) -> HDZItemCategoryTableViewCell {
		let cell: HDZItemCategoryTableViewCell = tableView.dequeueReusableCellWithIdentifier("HDZItemCategoryTableViewCell", forIndexPath: indexPath) as! HDZItemCategoryTableViewCell

		return cell
	}

}

extension HDZItemCategoryTableViewCell {
	
	func putBadge(value: Int) {
		
		// !!!バッジビュー
		if self.viewBadge == nil {
			let badgepos: CGPoint = CGPointMake(self.labelName.frame.origin.x, 0) // self.labelName.frame.origin.x
			let anchor:CGPoint = CGPointMake(1, 0)
			self.viewBadge = HDZBadgeView.createWithPosition(badgepos, anchor:anchor)
			self.addSubview(self.viewBadge)
		}
		self.viewBadge.updateBadge(value)
	}
	func eraseBadge() {
		self.viewBadge.hideBadge()
	}

}