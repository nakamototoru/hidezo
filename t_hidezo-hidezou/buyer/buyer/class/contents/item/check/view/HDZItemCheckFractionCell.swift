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
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}

}

// MARK: - Create
extension HDZItemCheckFractionCell {
	
	internal class func register(tableView: UITableView) {
		let bundle = Bundle.main
		let nib: UINib = UINib(nibName: "HDZItemCheckFractionCell", bundle: bundle)
		tableView.register(nib, forCellReuseIdentifier: "HDZItemCheckFractionCell")
	}

	internal class func dequeueReusableCell(tableView: UITableView, indexPath: IndexPath, delegate: HDZItemCheckCellDelegate) -> HDZItemCheckFractionCell {
		let cell: HDZItemCheckFractionCell = tableView.dequeueReusableCell(withIdentifier: "HDZItemCheckFractionCell", for: indexPath) as! HDZItemCheckFractionCell
		cell.delegate = delegate
		return cell
	}

}

// MARK: - API
extension HDZItemCheckFractionCell {
	
	func updateCart(newsizestr: String ) {
		
		let supplierId:String = self.order.supplierId
		try! HDZOrder.updateSize(supplierId: supplierId, itemId: self.order.itemId, dynamic: self.order.dynamic, newsize: newsizestr)
		
		self.delegate?.itemcheckcellReload()		
	}
	
	func deleteCartObject() {
		
		try! HDZOrder.deleteObject(object: self.order)
		self.delegate?.itemcheckcellReload()
	}

}

// MARK: - Action
extension HDZItemCheckFractionCell {
	
	@IBAction func didSelectedDelete(_ sender: Any) {
		
		deleteCartObject()
	}

	@IBAction func onChangeOrder(_ sender: Any) {
		
		// 分数変更ダイアログ
		let numScale:[String] = self.order.numScaleStr.components(separatedBy: "|")
		//self.order.numScaleStr.componentsSeparatedByString("|")
		
		let vc:HDZItemFractionViewController = HDZItemFractionViewController.createViewController(parent: self.parent, fractions: numScale, itemsize: self.order.size)
		vc.delegate = self
		//self.parent.presentPopupViewController(vc, animationType: MJPopupViewAnimationFade)
		self.parent.presentPopupViewController(popupViewController: vc)

	}
}

// MARK: - Delegate
extension HDZItemCheckFractionCell: HDZItemFractionViewControllerDelegate {
	
	func itemfractionSelected(fraction: String) {
		//分数入力
		if fraction != "0" {
			//更新
			self.updateCart(newsizestr: fraction)
		}
		else {
			// 注文削除処理
			deleteCartObject()
		}
	}
}
