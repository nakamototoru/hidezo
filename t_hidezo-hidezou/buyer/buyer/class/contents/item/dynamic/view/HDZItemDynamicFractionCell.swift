//
//  HDZItemDynamicFractionCell.swift
//  buyer
//
//  Created by デザミ on 2016/08/22.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit

protocol HDZItemDynamicFractionCellDelegate {
	func dynamicfractionReloadCell()
}

class HDZItemDynamicFractionCell: UITableViewCell {

	@IBOutlet weak var indexLabel: UILabel!
	@IBOutlet weak var itemName: UILabel!
	@IBOutlet weak var itemCount: UILabel!
	@IBOutlet weak var priceLabel: UILabel!

	private var dynamicItem: DynamicItem! = nil
//	var count: Int = 0
//		{
//		didSet {
//			self.itemCount.text = String(format: "%d", count)
//		}
//	}
	var itemsize:String = "0" {
		didSet {
			self.itemCount.text = itemsize
		}
	}
	
	private var attr_flg: AttrFlg = AttrFlg.direct
	private var supplierId: String = ""

	var parent:UITableViewController!
//	var delegate:HDZItemFractionViewControllerDelegate?
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// MARK: - Create
extension HDZItemDynamicFractionCell {
	
	internal class func register(tableView: UITableView) {
		let bundle: NSBundle = NSBundle.mainBundle()
		let nib: UINib = UINib(nibName: "HDZItemDynamicFractionCell", bundle: bundle)
		tableView.registerNib(nib, forCellReuseIdentifier: "HDZItemDynamicFractionCell")
	}
	
	internal class func dequeueReusableCell(tableView: UITableView, forIndexPath indexPath: NSIndexPath, dynamicItem: DynamicItem, attr_flg: AttrFlg, supplierId: String) -> HDZItemDynamicFractionCell {
		let cell: HDZItemDynamicFractionCell = tableView.dequeueReusableCellWithIdentifier("HDZItemDynamicFractionCell", forIndexPath: indexPath) as! HDZItemDynamicFractionCell
		cell.dynamicItem = dynamicItem
		cell.attr_flg = attr_flg
		cell.supplierId = supplierId
		//cell.count = 0
		
		return cell
	}
}

// MARK: - BuyCart
extension HDZItemDynamicFractionCell {
	
	private func updateItem() {
		
		do {
			try HDZOrder.add(self.supplierId, itemId: self.dynamicItem.id, size: self.itemsize, name: self.dynamicItem.item_name, price: self.dynamicItem.price, scale: "", standard: "", imageURL: nil, dynamic: true, numScale: self.dynamicItem.num_scale)
		} catch let error as NSError {
			debugPrint(error)
		}
	}
	
	static func getHeight() -> CGFloat {
		
		//return [[NSBundle mainBundle] loadNibNamed:className owner:self options:nil][0];
		
		let views: NSArray = NSBundle.mainBundle().loadNibNamed("HDZItemDynamicCell", owner: self, options: nil)
		let cell: HDZItemDynamicFractionCell = views.firstObject as! HDZItemDynamicFractionCell;
		let height :CGFloat = cell.frame.size.height;
		
		return height;
	}
}

// MARK: - Action
extension HDZItemDynamicFractionCell {
	
	@IBAction func onAddScale(sender: AnyObject) {
		
		if self.dynamicItem.num_scale.count > 0 {
			// 分数選択ダイアログ
			let vc:HDZItemFractionViewController = HDZItemFractionViewController.createViewController(self.parent, fractions: self.dynamicItem.num_scale, itemsize: self.itemsize)
			vc.delegate = self
			self.parent.presentPopupViewController(vc, animationType: MJPopupViewAnimationFade)
		}
	}
	
}

// MARK: - Delegate
extension HDZItemDynamicFractionCell: HDZItemFractionViewControllerDelegate {
	
	func itemfractionSelected(fraction: String) {
		//分数入力
		if fraction != "0" {
			//更新
			self.itemsize = fraction
			self.updateItem()
		}
		else {
			self.itemsize = "0"
			// 注文削除処理
			try! HDZOrder.deleteItem(self.supplierId, itemId: self.dynamicItem.id, dynamic: true)
		}
	}
}