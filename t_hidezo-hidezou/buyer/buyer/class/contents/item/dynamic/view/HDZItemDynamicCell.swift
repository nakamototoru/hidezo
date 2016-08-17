//
//  HDZItemDynamicCell.swift
//  buyer
//
//  Created by Shun Nakahara on 7/31/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZItemDynamicCell: UITableViewCell {

    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemCount: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    private var dynamicItem: DynamicItem! = nil
    var count: Int = 0 {
        didSet {
            self.itemCount.text = String(format: "%d", count)
        }
    }
    
    private var attr_flg: AttrFlg = AttrFlg.direct
    private var supplierId: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension HDZItemDynamicCell {
    
    internal class func register(tableView: UITableView) {
        let bundle: NSBundle = NSBundle.mainBundle()
        let nib: UINib = UINib(nibName: "HDZItemDynamicCell", bundle: bundle)
        tableView.registerNib(nib, forCellReuseIdentifier: "HDZItemDynamicCell")
    }
    
    internal class func dequeueReusableCell(tableView: UITableView, forIndexPath indexPath: NSIndexPath, dynamicItem: DynamicItem, attr_flg: AttrFlg, supplierId: Int) -> HDZItemDynamicCell {
        let cell: HDZItemDynamicCell = tableView.dequeueReusableCellWithIdentifier("HDZItemDynamicCell", forIndexPath: indexPath) as! HDZItemDynamicCell
        cell.dynamicItem = dynamicItem
        cell.attr_flg = attr_flg
        cell.supplierId = supplierId
        cell.count = 0
        return cell
    }
}

extension HDZItemDynamicCell {
    
    private func updateItem() {
        
        do {
            try HDZOrder.add(self.supplierId, itemId: self.dynamicItem.id, size: self.count, name: self.dynamicItem.item_name, price: self.dynamicItem.price, scale: "", standard: "", imageURL: nil, dynamic: true)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
	
	static func getHeight() -> CGFloat {
		
		//return [[NSBundle mainBundle] loadNibNamed:className owner:self options:nil][0];
		
		let views: NSArray = NSBundle.mainBundle().loadNibNamed("HDZItemDynamicCell", owner: self, options: nil)
		let cell: HDZItemDynamicCell = views.firstObject as! HDZItemDynamicCell;
		let height :CGFloat = cell.frame.size.height;
		
		return height;
	}
}

extension HDZItemDynamicCell {
    
    @IBAction func didSelectedAdd(button: UIButton) {
        self.count += 1

        if self.count >= Int.max {
            self.count = Int.max
        }
        
        self.updateItem()
    }
    
    @IBAction func didSelectedSub(button: UIButton) {
        self.count -= 1

        if self.count <= 0 {
            self.count = 0
            try! HDZOrder.deleteItem(self.supplierId, itemId: self.dynamicItem.id, dynamic: true)
        } else {
            self.updateItem()
        }
    }
}
