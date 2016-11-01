//
//  HDZOrderDetailResultCell.swift
//  buyer
//
//  Created by 庄俊亮 on 2016/11/01.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZOrderDetailResultCell: UITableViewCell {

    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var postageLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var chargeLabel: UILabel!
    @IBOutlet weak var deliveredDayLabel: UILabel!
    @IBOutlet weak var deliveredPlaceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    internal class func register(tableView: UITableView) {
        let bundle: NSBundle = NSBundle.mainBundle()
        let nib: UINib = UINib(nibName: "HDZOrderDetailResultCell", bundle: bundle)
        tableView.registerNib(nib, forCellReuseIdentifier: "HDZOrderDetailResultCell")
    }
    
    internal class func dequeueReusableCell(controller: HDZOrderDetailTableViewController, tableView: UITableView, for indexPath: NSIndexPath) -> HDZOrderDetailResultCell {
        
        let cell: HDZOrderDetailResultCell = tableView.dequeueReusableCellWithIdentifier("HDZOrderDetailResultCell", forIndexPath: indexPath) as! HDZOrderDetailResultCell
        
//        cell.viewController = controller
//        cell.orderDetailItem = orderDetailItem
//        cell.attr_flg = attr_flg
//        cell.indexLabel.text = String(format: "%d", indexPath.row + 1)
//        cell.itemNameLabel.text = orderDetailItem.name
//        
//        cell.priceLabel.text = String(format: "価格：%d円", priceValue(orderDetailItem.price, order_num: orderDetailItem.order_num, attr_flg: attr_flg))
//        
//        if orderDetailItem.scale != nil && orderDetailItem.standard != nil && orderDetailItem.loading != nil {
//            cell.detailLabel.text = String(format: "（単価:%@円/%@・%@/%@）",orderDetailItem.price, orderDetailItem.standard ?? "", orderDetailItem.loading ?? "", orderDetailItem.scale ?? "")
//        } else {
//            cell.detailLabel.text = nil
//        }
//        
//        cell.scaleLabel.text = String(format: "数量: %@%@", orderDetailItem.order_num, orderDetailItem.scale ?? "")
        
        return cell
    }
    
//    internal class func priceValue(price: String, order_num: String, attr_flg: AttrFlg) -> Int {
//        
//        let prices: [String] = price.componentsSeparatedByString(",")
//        if prices.count < 1 {
//            return 0
//        }
//        
//        
//        if prices.count == 1 {
//            guard let price: Int = Int(prices[0]) else {
//                return 0
//            }
//            
//            guard let orderNum: Int = Int(order_num) else {
//                return 0
//            }
//            
//            return price * orderNum
//        } else {
//            guard let orderNum: Int = Int(order_num) else {
//                return 0
//            }
//            
//            switch attr_flg {
//            case .direct:
//                guard let price: Int = Int(prices[2]) else {
//                    return 0
//                }
//                
//                return price * orderNum
//            case .group:
//                guard let price: Int = Int(prices[1]) else {
//                    return 0
//                }
//
//                return price * orderNum
//            case .other:
//                
//                guard let price: Int = Int(prices[0]) else {
//                    return 0
//                }
//                
//                return price * orderNum
//            }
//        }
//    }
    
    static func getHeight() -> CGFloat {
        
        let views: NSArray = NSBundle.mainBundle().loadNibNamed("HDZOrderDetailResultCell", owner: self, options: nil)!
        let cell: HDZOrderDetailResultCell = views.firstObject as! HDZOrderDetailResultCell;
        let height :CGFloat = cell.frame.size.height;
        
        return height;
    }

}
