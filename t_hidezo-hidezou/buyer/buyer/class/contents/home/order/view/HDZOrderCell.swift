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
    
    private var orderInfo: OrderInfo! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension HDZOrderCell {
    
    internal class func register(tableView: UITableView) {
        let bundle: NSBundle = NSBundle.mainBundle()
        let nib: UINib = UINib(nibName: "HDZOrderCell", bundle: bundle)
        tableView.registerNib(nib, forCellReuseIdentifier: "HDZOrderCell")
    }
    
    internal class func dequeueReusableCell(tableView: UITableView, for indexPath: NSIndexPath, orderInfo: OrderInfo) -> HDZOrderCell {
        let cell: HDZOrderCell = tableView.dequeueReusableCellWithIdentifier("HDZOrderCell", forIndexPath: indexPath) as! HDZOrderCell
        cell.orderInfo = orderInfo
        cell.indexLabel.text = String(format: "%d", indexPath.row + 1)
        cell.shopNameLabel.text = orderInfo.supplier_name
        cell.deliverDateLabel.text = orderInfo.deliver_at + "日納品"
        cell.orderDateLabel.text = orderInfo.order_at + "日注文"
        return cell
    }
}