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

	var dynamicItem: DynamicItem! = nil
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
	
	var attr_flg: AttrFlg = AttrFlg.direct
	var supplierId: String = ""

	var parent:UITableViewController!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// MARK: - Create
extension HDZItemDynamicFractionCell {
	
	internal class func register(tableView: UITableView) {
		let bundle = Bundle.main
		let nib: UINib = UINib(nibName: "HDZItemDynamicFractionCell", bundle: bundle)
		tableView.register(nib, forCellReuseIdentifier: "HDZItemDynamicFractionCell")
	}
	
	internal class func dequeueReusableCell(tableView: UITableView, forIndexPath indexPath: IndexPath, dynamicItem: DynamicItem, attr_flg: AttrFlg, supplierId: String) -> HDZItemDynamicFractionCell {
		let cell: HDZItemDynamicFractionCell = tableView.dequeueReusableCell(withIdentifier: "HDZItemDynamicFractionCell", for: indexPath) as! HDZItemDynamicFractionCell
		cell.dynamicItem = dynamicItem
		cell.attr_flg = attr_flg
		cell.supplierId = supplierId
		//cell.count = 0
		
		return cell
	}
}

// MARK: - BuyCart
extension HDZItemDynamicFractionCell {
	
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
		let cell: HDZItemDynamicFractionCell = viewFirst as! HDZItemDynamicFractionCell;
		let height :CGFloat = cell.frame.size.height;
		
		return height;
	}
}

// MARK: - Action
extension HDZItemDynamicFractionCell {
	
	@IBAction func onAddScale(_ sender: Any) {
		
		if self.dynamicItem.num_scale.count > 0 {
			// 分数選択ダイアログ
			let vc:HDZItemFractionViewController = HDZItemFractionViewController.createViewController(parent: self.parent, fractions: self.dynamicItem.num_scale, itemsize: self.itemsize)
			vc.delegate = self
			//self.parent.presentPopupViewController(vc, animationType: MJPopupViewAnimationFade)
			self.parent.presentPopupViewController(popupViewController: vc)
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
			try! HDZOrder.deleteItem(supplierId: self.supplierId, itemId: self.dynamicItem.id, dynamic: true)
		}
	}
}
