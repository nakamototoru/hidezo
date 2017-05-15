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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension HDZItemCategoryTableViewCell {
	
	internal class func register(tableView: UITableView) {
		let bundle = Bundle.main
		let nib: UINib = UINib(nibName: "HDZItemCategoryTableViewCell", bundle: bundle)
		tableView.register(nib, forCellReuseIdentifier: "HDZItemCategoryTableViewCell")
	}

	internal class func dequeueReusableCell(tableView: UITableView, forIndexPath indexPath: IndexPath) -> HDZItemCategoryTableViewCell {
		let cell: HDZItemCategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HDZItemCategoryTableViewCell", for: indexPath) as! HDZItemCategoryTableViewCell

		return cell
	}

}

extension HDZItemCategoryTableViewCell {
	
	func putBadge(value: Int) {

		// !!!バッジビュー
		if self.viewBadge == nil {
			let badgepos: CGPoint = CGPoint(x: self.labelName.frame.origin.x, y: 0) // self.labelName.frame.origin.x
			let anchor:CGPoint = CGPoint(x: 1, y: 0)
			self.viewBadge = HDZBadgeView.createWithPosition(position: badgepos, anchor:anchor)
			self.addSubview(self.viewBadge)
		}
		self.viewBadge.updateBadge(value: value)
	}

}
