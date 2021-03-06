//
//  HDZOrderDetailCell.swift
//  seller
//
//  Created by NakaharaShun on 6/22/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZOrderDetailCell: UITableViewCell {

    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var scaleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
	var orderDetailItem: OrderDetailItem! = nil
	var viewController: HDZOrderDetailTableViewController! = nil
	var attr_flg: AttrFlg = .other
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

// MARK: - static
extension HDZOrderDetailCell {
    
    internal class func register(tableView: UITableView) {
        let bundle = Bundle.main
        let nib: UINib = UINib(nibName: "HDZOrderDetailCell", bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: "HDZOrderDetailCell")
    }
    
    internal class func dequeueReusableCell(controller: HDZOrderDetailTableViewController, tableView: UITableView, for indexPath: IndexPath, orderDetailItem: OrderDetailItem, attr_flg: AttrFlg) -> HDZOrderDetailCell {
		
        let cell: HDZOrderDetailCell = tableView.dequeueReusableCell(withIdentifier: "HDZOrderDetailCell", for: indexPath) as! HDZOrderDetailCell
		
        cell.viewController = controller
        cell.orderDetailItem = orderDetailItem
        cell.attr_flg = attr_flg
        cell.indexLabel.text = String(format: "%d", indexPath.row + 1)
        cell.itemNameLabel.text = orderDetailItem.name
		
        cell.priceLabel.text = String(format: "価格：%d円", priceValue(price: orderDetailItem.price, order_num: orderDetailItem.order_num, attr_flg: attr_flg))
        
        if orderDetailItem.scale != nil && orderDetailItem.standard != nil && orderDetailItem.loading != nil {
			cell.detailLabel.text = String(format: "（単価:%@円/%@・%@/%@）",orderDetailItem.price, orderDetailItem.standard ?? "", orderDetailItem.loading ?? "", orderDetailItem.scale ?? "")
        } else {
            cell.detailLabel.text = nil
        }
        
        cell.scaleLabel.text = String(format: "数量: %@%@", orderDetailItem.order_num, orderDetailItem.scale ?? "")
        
        return cell
    }
    
    internal class func priceValue(price: String, order_num: String, attr_flg: AttrFlg) -> Int {
        
        let prices: [String] = price.components(separatedBy: ",") //componentsSeparatedByString(",")
        if prices.count < 1 {
            return 0
        }
        
        
        if prices.count == 1 {
            guard let price: Int = Int(prices[0]) else {
                return 0
            }
            
            guard let orderNum: Int = Int(order_num) else {
                return 0
            }
            
            return price * orderNum
        } else {
            guard let orderNum: Int = Int(order_num) else {
                return 0
            }
            
            switch attr_flg {
            case .direct:
                guard let price: Int = Int(prices[2]) else {
                    return 0
                }
                
                return price * orderNum
            case .group:
                guard let price: Int = Int(prices[1]) else {
                    return 0
                }

                return price * orderNum
            case .other:

                guard let price: Int = Int(prices[0]) else {
                    return 0
                }
                
                return price * orderNum
            }
        }
    }
	
	static func getHeight() -> CGFloat {
		
		let views = Bundle.main.loadNibNamed("HDZOrderDetailCell", owner: self, options: nil)!
		let viewFirst = views.first
		let cell: HDZOrderDetailCell = viewFirst as! HDZOrderDetailCell;
		let height :CGFloat = cell.frame.size.height;
		
		return height;
	}
	
}

// MARK: - action
extension HDZOrderDetailCell {

    @IBAction func didSelectedEdit(_ sender: Any) {
        let controller: HDZOrderScaleViewController = HDZOrderScaleViewController.createViewController(viewController: self.viewController, cell: self, orderDetailItem: self.orderDetailItem)
        self.viewController.present(controller, animated: true, completion: nil)
    }
}

// MARK: - HDZOrderScaleViewControllerDelegate
extension HDZOrderDetailCell: HDZOrderScaleViewControllerDelegate {
    
    func didSelectRow(numScale: String, row: Int) {
        self.scaleLabel.text = String(format: "数量: %@%@", numScale, orderDetailItem.scale ?? "")
        
        self.priceLabel.text = String(format: "価格：%d円", HDZOrderDetailCell.priceValue(price: self.orderDetailItem.price, order_num: numScale, attr_flg: self.attr_flg))
    }
}
