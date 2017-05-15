//
//  HDZOrderCell.swift
//  seller
//
//  Created by NakaharaShun on 6/20/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZOrderCell: UITableViewCell {

    
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var deliverDateLabel: UILabel!
    
	var orderInfo: OrderInfo! = nil
	
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

extension HDZOrderCell {
    
    internal class func register(tableView: UITableView) {
        let bundle = Bundle.main
        let nib: UINib = UINib(nibName: "HDZOrderCell", bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: "HDZOrderCell")
    }
    
    internal class func dequeueReusableCell(tableView: UITableView, for indexPath: IndexPath, orderInfo: OrderInfo) -> HDZOrderCell {
        let cell: HDZOrderCell = tableView.dequeueReusableCell(withIdentifier: "HDZOrderCell", for: indexPath) as! HDZOrderCell
        cell.orderInfo = orderInfo
        cell.indexLabel.text = String(format: "%d", indexPath.row + 1)
        cell.shopNameLabel.text = orderInfo.supplier_name
		if orderInfo.deliver_at != nil {
			cell.deliverDateLabel.text = orderInfo.deliver_at! + "納品"
		}
        cell.orderDateLabel.text = orderInfo.order_at + "注文"
        return cell
    }
}

// MARK: - Badge
extension HDZOrderCell {
	
	func putBadge(value: Int) {
		
		// !!!バッジビュー
		if self.viewBadge == nil {
			let badgepos: CGPoint = CGPoint(x: self.frame.size.width, y: 0)
			let anchor:CGPoint = CGPoint(x: 1, y: 0)
			self.viewBadge = HDZBadgeView.createWithPosition(position: badgepos, anchor:anchor)
			self.addSubview(self.viewBadge)
		}
		self.viewBadge.updateBadge(value: value)
	}

}
