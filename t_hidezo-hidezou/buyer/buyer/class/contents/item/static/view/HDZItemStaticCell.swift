//
//  HDZItemStaticCell.swift
//  buyer
//
//  Created by Shun Nakahara on 7/31/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire

class HDZItemStaticCell: UITableViewCell {

    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemCount: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var labelUnitPrice: UILabel!

	var parent:UITableViewController!
	
    private var staticItem: StaticItem!
    private var attr_flg: AttrFlg = AttrFlg.direct
    private var supplierId: Int = 0
	var itemsize:String = "0" {
		didSet {
			self.itemCount.text = itemsize
		}
	}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		//画像タップ
		let myTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZItemStaticCell.tapGestureFromImageView1(_:)))
		self.iconImageView.addGestureRecognizer(myTap)
		
		//名前タップ
//		let nameTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZItemStaticCell.tapGestureFromNameLabel(_:)))
//		self.itemName.addGestureRecognizer(nameTap)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

// MARK: - Create
extension HDZItemStaticCell {

    internal class func register(tableView: UITableView) {
        let bundle: NSBundle = NSBundle.mainBundle()
        let nib: UINib = UINib(nibName: "HDZItemStaticCell", bundle: bundle)
        tableView.registerNib(nib, forCellReuseIdentifier: "HDZItemStaticCell")
    }
    
    internal class func dequeueReusableCell(tableView: UITableView, forIndexPath indexPath: NSIndexPath, staticItem: StaticItem, attr_flg: AttrFlg, supplierId: Int) -> HDZItemStaticCell {
		
		let cell: HDZItemStaticCell = tableView.dequeueReusableCellWithIdentifier("HDZItemStaticCell", forIndexPath: indexPath) as! HDZItemStaticCell
        cell.staticItem = staticItem
        cell.attr_flg = attr_flg
        cell.supplierId = supplierId
        
        cell.indexLabel.text = String(format: "%d", indexPath.row + 1)
        cell.itemName.text = staticItem.name
		
        requestImage(staticItem.image) { (image) in
            cell.iconImageView.image = image
			
//			debugPrint("IMAGE in CELL :")
//			debugPrint(cell.iconImageView.image)
        }

		cell.itemsize = "0"
        if let item: HDZOrder = try! HDZOrder.queries(supplierId, itemId: staticItem.id, dynamic: false) {
			if let _: Int = Int(item.size) {
				cell.itemsize = item.size
			}
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
extension HDZItemStaticCell {
	
	static func getHeight() -> CGFloat {
		
		let views: NSArray = NSBundle.mainBundle().loadNibNamed("HDZItemStaticCell", owner: self, options: nil)
		let cell: HDZItemStaticCell = views.firstObject as! HDZItemStaticCell;
		let height :CGFloat = cell.frame.size.height;
		
		return height;
	}

}

// MARK: - Gesture
extension HDZItemStaticCell {
	
	func tapGestureFromImageView1(sender:UITapGestureRecognizer){

		//詳細画面
		let controller: HDZItemStaticDetailViewController = HDZItemStaticDetailViewController.createViewController(self.staticItem)
		self.parent.navigationController?.pushViewController(controller, animated: true)
	}

	func tapGestureFromNameLabel(sender:UITapGestureRecognizer){
		// TODO:消去
	}
}

// MARK: - API
extension HDZItemStaticCell {
    
    private class func requestImage(url: NSURL, completion: (image: UIImage?) -> Void) {
		
        let completionHandler: (Response<NSData, NSError>) -> Void = { (response: Response<NSData, NSError>) in
            if response.result.error != nil {
				let sakanaimage:UIImage = UIImage(named: "sakana")!
				completion(image: sakanaimage)
            }
			else {
                if let data: NSData = response.result.value {
                    if let resultImage: UIImage = UIImage(data: data) {
						
//						debugPrint(resultImage.size)
						
                        completion(image: resultImage)
                    }
                }
				else {
					let sakanaimage:UIImage = UIImage(named: "sakana")!
					completion(image: sakanaimage)
				}
            }
        }
        let _: Alamofire.Request? = Alamofire.request(.GET, url).responseData(completionHandler: completionHandler)
    }
}

// MARK: - BuyCart
extension HDZItemStaticCell {
    
    private func updateItem() {
        
        do {
            try HDZOrder.add(self.supplierId, itemId: self.staticItem.id, size: self.itemsize, name: self.staticItem.name, price: self.staticItem.price, scale: self.staticItem.scale, standard: self.staticItem.standard, imageURL: self.staticItem.image.absoluteString, dynamic: false, numScale: self.staticItem.num_scale)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
}

// MARK: - Action
extension HDZItemStaticCell {
    
    @IBAction func didSelectedAdd(button: UIButton) {
		
		var value:Int = Int(self.itemsize)!
		value += 1
		if (value > 100) {
			value = 100
		}
		self.itemsize = String(value)
		
        self.updateItem()
    }
    
    @IBAction func didSelectedSub(button: UIButton) {
		
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
			try! HDZOrder.deleteItem(self.supplierId, itemId: self.staticItem.id, dynamic: false)
		}
    }
}

