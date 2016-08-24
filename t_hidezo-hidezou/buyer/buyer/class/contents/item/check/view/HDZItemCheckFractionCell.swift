//
//  HDZItemCheckFractionCell.swift
//  buyer
//
//  Created by デザミ on 2016/08/24.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZItemCheckFractionCell: UITableViewCell {

	@IBOutlet weak var indexText: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	
	@IBOutlet weak var sizeLabel: UILabel!
	
	var order: HDZOrder! = nil
	weak var delegate: HDZItemCheckCellDelegate?
	
	var parent:UITableViewController!

	
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
extension HDZItemCheckFractionCell {
	
	internal class func register(tableView: UITableView) {
		let bundle: NSBundle = NSBundle.mainBundle()
		let nib: UINib = UINib(nibName: "HDZItemCheckFractionCell", bundle: bundle)
		tableView.registerNib(nib, forCellReuseIdentifier: "HDZItemCheckFractionCell")
	}

	internal class func dequeueReusableCell(tableView: UITableView, indexPath: NSIndexPath, delegate: HDZItemCheckCellDelegate) -> HDZItemCheckFractionCell {
		let cell: HDZItemCheckFractionCell = tableView.dequeueReusableCellWithIdentifier("HDZItemCheckFractionCell", forIndexPath: indexPath) as! HDZItemCheckFractionCell
		cell.delegate = delegate
		return cell
	}

}

// MARK: - API
extension HDZItemCheckFractionCell {
	
	private func updateCart(newsizestr: String ) {
		
		let supplierId:Int = Int( self.order.supplierId )
		try! HDZOrder.updateSize(supplierId, itemId: self.order.itemId, dynamic: self.order.dynamic, newsize: newsizestr)
		
		self.delegate?.itemcheckcellReload()		
	}
	
	private func deleteCartObject() {
		
		try! HDZOrder.deleteObject(self.order)
		self.delegate?.itemcheckcellReload()
	}

}

// MARK: - Action
extension HDZItemCheckFractionCell {
	
	@IBAction func didSelectedDelete(button: UIButton) {
		
		deleteCartObject()
	}

	@IBAction func onChangeOrder(sender: AnyObject) {
		
		// TODO: 分数変更ダイアログ
		NSLog("TODO: 分数変更ダイアログ")

		UIWarning.WarningWithTitle("工事中", message: "ご迷惑をおかけします")
		
//		let vc:HDZItemFractionViewController = HDZItemFractionViewController.createViewController(self.parent, fractions: self.dynamicItem.num_scale, itemsize: self.order.size)
//		vc.delegate = self
//		self.parent.presentPopupViewController(vc, animationType: MJPopupViewAnimationFade)

	}
}

// MARK: - Delegate
extension HDZItemCheckFractionCell: HDZItemFractionViewControllerDelegate {
	
	func itemfractionSelected(fraction: String) {
		//分数入力
		if fraction != "0" {
			//更新
			self.updateCart(fraction)
		}
		else {
			// 注文削除処理
			deleteCartObject()
		}
	}
}