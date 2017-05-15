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
    
	var dynamicItem: DynamicItem! = nil
//    var count: Int = 0
//		{
//        didSet {
//            self.itemCount.text = String(format: "%d", count)
//        }
//    }
	var itemsize:String = "0" {
		didSet {
			self.itemCount.text = itemsize
		}
	}
	
	var attr_flg: AttrFlg = AttrFlg.direct
	var supplierId: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension HDZItemDynamicCell {
    
    internal class func register(tableView: UITableView) {
        let bundle = Bundle.main
        let nib: UINib = UINib(nibName: "HDZItemDynamicCell", bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: "HDZItemDynamicCell")
    }
    
    internal class func dequeueReusableCell(tableView: UITableView, forIndexPath indexPath: IndexPath, dynamicItem: DynamicItem, attr_flg: AttrFlg, supplierId: String) -> HDZItemDynamicCell {
        let cell: HDZItemDynamicCell = tableView.dequeueReusableCell(withIdentifier: "HDZItemDynamicCell", for: indexPath) as! HDZItemDynamicCell
        cell.dynamicItem = dynamicItem
        cell.attr_flg = attr_flg
        cell.supplierId = supplierId
//        cell.count = 0
        return cell
    }
}

extension HDZItemDynamicCell {
    
	func updateItem() {
        
        do {
            try HDZOrder.add(supplierId: self.supplierId, itemId: self.dynamicItem.id, size: self.itemsize, name: self.dynamicItem.item_name, price: self.dynamicItem.price, scale: "", standard: "", imageURL: nil, dynamic: true, numScale: self.dynamicItem.num_scale)
        } catch let error as NSError {
			#if DEBUG
            debugPrint(error)
			#endif
        }
    }
	
	static func getHeight() -> CGFloat {
		
		//return [[NSBundle mainBundle] loadNibNamed:className owner:self options:nil][0];
		
		let views = Bundle.main.loadNibNamed("HDZItemDynamicCell", owner: self, options: nil)!
		let viewFirst = views.first
		let cell: HDZItemDynamicCell = viewFirst as! HDZItemDynamicCell
		let height :CGFloat = cell.frame.size.height
		
		return height;
	}
}

// MARK: - Action
extension HDZItemDynamicCell {
    
    @IBAction func didSelectedAdd(_ sender: Any) {
		
		var value:Int = Int(self.itemsize)!
		value += 1
		if (value > 100) {
			value = 100
		}
		self.itemsize = String(value)
		
        self.updateItem()
    }
    
    @IBAction func didSelectedSub(_ sender: Any) {
		
		var value:Int = Int(self.itemsize)!
		value -= 1
		if (value > 0) {
			//更新
			self.itemsize = String(value)
			self.updateItem()
		}
		else {
			value = 0
			self.itemsize = String(value)
			//削除
			try! HDZOrder.deleteItem(supplierId: self.supplierId, itemId: self.dynamicItem.id, dynamic: true)
		}
    }
}
