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
	
	private var staticItem: StaticItem!
	private var attr_flg: AttrFlg = AttrFlg.direct
	private var supplierId: String = ""
	private var itemsize:String = "0" {
		didSet {
			self.itemCount.text = itemsize
		}
	}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		//画像タップ
		let myTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZItemStaticFractionCell.tapGestureFromImageView1(_:)))
		self.iconImageView.addGestureRecognizer(myTap)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// MARK: - Create
extension HDZItemStaticFractionCell {
	
	internal class func register(tableView: UITableView) {
		let bundle: NSBundle = NSBundle.mainBundle()
		let nib: UINib = UINib(nibName: "HDZItemStaticFractionCell", bundle: bundle)
		tableView.registerNib(nib, forCellReuseIdentifier: "HDZItemStaticFractionCell")
	}
	
	internal class func dequeueReusableCell(tableView: UITableView, forIndexPath indexPath: NSIndexPath, staticItem: StaticItem, attr_flg: AttrFlg, supplierId: String) -> HDZItemStaticFractionCell {
		
		let cell: HDZItemStaticFractionCell = tableView.dequeueReusableCellWithIdentifier("HDZItemStaticFractionCell", forIndexPath: indexPath) as! HDZItemStaticFractionCell
		cell.staticItem = staticItem
		cell.attr_flg = attr_flg
		cell.supplierId = supplierId
		
		cell.indexLabel.text = String(format: "%d", indexPath.row + 1)
		cell.itemName.text = staticItem.name
		
		//画像
//		request(staticItem.image) { (image) in
//			cell.iconImageView.image = image
//		}
		
		// アイテム数
		if let item: HDZOrder = try! HDZOrder.queries(supplierId, itemId: staticItem.id, dynamic: false) {
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
			cell.priceLabel.text = String(format: "(\(staticItem.standard)・\(String(staticItem.loading))/\(staticItem.scale))")
		}
		
		cell.labelUnitPrice.text = String(format: "単価:\(staticItem.price)円/\(staticItem.scale)")
		
		return cell
	}
}

// MARK: - Cell
extension HDZItemStaticFractionCell {
	
	static func getHeight() -> CGFloat {
		
		let views: NSArray = NSBundle.mainBundle().loadNibNamed("HDZItemStaticFractionCell", owner: self, options: nil)
		let cell: HDZItemStaticFractionCell = views.firstObject as! HDZItemStaticFractionCell;
		let height :CGFloat = cell.frame.size.height;
		
		return height;
	}
	
}

// MARK: - Gesture
extension HDZItemStaticFractionCell {
	
	func tapGestureFromImageView1(sender:UITapGestureRecognizer){
		
		//詳細画面
		let controller: HDZItemStaticDetailViewController = HDZItemStaticDetailViewController.createViewController(self.staticItem)
		self.parent.navigationController?.pushViewController(controller, animated: true)
	}
	
}

// MARK: - API
//extension HDZItemStaticFractionCell {
//	
//	private class func request(url: NSURL, completion: (image: UIImage?) -> Void) {
//		
//		let completionHandler: (Response<NSData, NSError>) -> Void = { (response: Response<NSData, NSError>) in
//			if response.result.error != nil {
//				let sakanaimage:UIImage = UIImage(named: "sakana")!
//				completion(image: sakanaimage)
//			}
//			else {
//				if let data: NSData = response.result.value {
//					
//					if let resultImage: UIImage = UIImage(data: data) {
//						completion(image: resultImage)
//					}
//				}
//				else {
//					let sakanaimage:UIImage = UIImage(named: "sakana")!
//					completion(image: sakanaimage)
//				}
//			}
//		}
//		let _: Alamofire.Request? = Alamofire.request(.GET, url).responseData(completionHandler: completionHandler)
//	}
//}

// MARK: - BuyCart
extension HDZItemStaticFractionCell {
	
	private func updateItem() {
		
		do {
			try HDZOrder.add(self.supplierId, itemId: self.staticItem.id, size: self.itemsize, name: self.staticItem.name, price: self.staticItem.price, scale: self.staticItem.scale, standard: self.staticItem.standard, imageURL: self.staticItem.image.absoluteString, dynamic: false, numScale: self.staticItem.num_scale)
		} catch let error as NSError {
			#if DEBUG
			debugPrint(error)
			#endif
		}
	}
}

// MARK: - Action
extension HDZItemStaticFractionCell {
	
	@IBAction func onFractionSelect(sender: AnyObject) {
		
		if self.staticItem.num_scale.count > 0 {
			// 分数選択ダイアログ
			let vc:HDZItemFractionViewController = HDZItemFractionViewController.createViewController(self.parent, fractions: self.staticItem.num_scale, itemsize: self.itemsize)
			vc.delegate = self
			self.parent.presentPopupViewController(vc, animationType: MJPopupViewAnimationFade)
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
			try! HDZOrder.deleteItem(self.supplierId, itemId: self.staticItem.id, dynamic: false)
		}
		
	}
}
