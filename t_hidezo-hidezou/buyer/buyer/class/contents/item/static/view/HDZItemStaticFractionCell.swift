//
//  HDZItemStaticFractionCell.swift
//  buyer
//
//  Created by デザミ on 2016/08/23.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit
//import Alamofire

protocol HDZItemStaticFractionCellDelegate {
	func staticfractionReloadCell()
}

class HDZItemStaticFractionCell: UITableViewCell {

	@IBOutlet weak var indexLabel: UILabel!
	@IBOutlet weak var itemName: UILabel!
	@IBOutlet weak var itemCount: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var labelUnitPrice: UILabel!
	
	var parent:UITableViewController!
	var delegate:HDZItemFractionViewControllerDelegate?
	
	var staticItem: StaticItem!
	var attr_flg: AttrFlg = AttrFlg.direct
	var supplierId: String = ""
	var itemsize:String = "0" {
		didSet {
			self.itemCount.text = itemsize
		}
	}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		//画像タップ
		let myTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZItemStaticFractionCell.tapGestureFromImageView1))
		self.iconImageView.addGestureRecognizer(myTap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// MARK: - Create
extension HDZItemStaticFractionCell {
	
	internal class func register(tableView: UITableView) {
		let bundle = Bundle.main
		let nib: UINib = UINib(nibName: "HDZItemStaticFractionCell", bundle: bundle)
		tableView.register(nib, forCellReuseIdentifier: "HDZItemStaticFractionCell")
	}
	
	internal class func dequeueReusableCell(tableView: UITableView, forIndexPath indexPath: IndexPath, staticItem: StaticItem, attr_flg: AttrFlg, supplierId: String) -> HDZItemStaticFractionCell {
		
		let cell: HDZItemStaticFractionCell = tableView.dequeueReusableCell(withIdentifier: "HDZItemStaticFractionCell", for: indexPath) as! HDZItemStaticFractionCell
		cell.staticItem = staticItem
		cell.attr_flg = attr_flg
		cell.supplierId = supplierId
		
		cell.indexLabel.text = String(format: "%d", indexPath.row + 1)
		cell.itemName.text = staticItem.name
				
		// アイテム数
		if let item: HDZOrder = try! HDZOrder.queries(supplierId: supplierId, itemId: staticItem.id, dynamic: false) {
			cell.itemsize = item.size
		} else {
			cell.itemsize = "0"
		}
		
		// !!!:デザミシステム
		let standardstr:String = "\(staticItem.standard)"
		let loadingstr:String = "\(staticItem.loading)"
		let scalestr:String = "\(staticItem.scale)"
		if standardstr.isEmpty && loadingstr.isEmpty && scalestr.isEmpty {
			cell.priceLabel.text = ""
		}
		else {
			//cell.priceLabel.text = String(format: "(\(staticItem.standard)・\(String(staticItem.loading))/\(staticItem.scale))")
			
			cell.priceLabel.text = "(" + staticItem.standard + "・" + staticItem.loading + "/" + staticItem.scale + ")"
		}
		
		cell.labelUnitPrice.text = String(format: "単価:\(staticItem.price)円/\(staticItem.scale)")
		
		return cell
	}
}

// MARK: - Cell
extension HDZItemStaticFractionCell {
	
	static func getHeight() -> CGFloat {
		
		let views = Bundle.main.loadNibNamed("HDZItemStaticFractionCell", owner: self, options: nil)!
		let viewFirst = views.first
		let cell: HDZItemStaticFractionCell = viewFirst as! HDZItemStaticFractionCell
		let height :CGFloat = cell.frame.size.height
		
		return height
	}
	
}

// MARK: - Gesture
extension HDZItemStaticFractionCell {
	
	func tapGestureFromImageView1(sender:UITapGestureRecognizer){
		
		//詳細画面
		let controller: HDZItemStaticDetailViewController = HDZItemStaticDetailViewController.createViewController(staticItem: self.staticItem)
		self.parent.navigationController?.pushViewController(controller, animated: true)
	}
	
}

// MARK: - BuyCart
extension HDZItemStaticFractionCell {
	
	func updateItem() {
		
		do {
			try HDZOrder.add(supplierId: self.supplierId, itemId: self.staticItem.id, size: self.itemsize, name: self.staticItem.name, price: self.staticItem.price, scale: self.staticItem.scale, standard: self.staticItem.standard, imageURL: self.staticItem.image.absoluteString, dynamic: false, numScale: self.staticItem.num_scale)
		} catch let error as NSError {
			#if DEBUG
			debugPrint(error)
			#endif
		}
	}
}

// MARK: - Action
extension HDZItemStaticFractionCell {
	
	@IBAction func onFractionSelect(_ sender: Any) {
		
		if self.staticItem.num_scale.count > 0 {
			// 分数選択ダイアログ
			let vc:HDZItemFractionViewController = HDZItemFractionViewController.createViewController(parent: self.parent, fractions: self.staticItem.num_scale, itemsize: self.itemsize)
			vc.delegate = self
//			self.parent.presentPopupViewController(vc, animationType: MJPopupViewAnimation.Fade)
			self.parent.presentPopupViewController(popupViewController: vc)
		}
	}
}

// MARK: - Delegate
extension HDZItemStaticFractionCell: HDZItemFractionViewControllerDelegate {
	
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
			try! HDZOrder.deleteItem(supplierId: self.supplierId, itemId: self.staticItem.id, dynamic: false)
		}
		
	}
}
