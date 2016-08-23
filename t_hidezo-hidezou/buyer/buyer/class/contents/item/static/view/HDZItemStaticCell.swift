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

//    private var count: Int = 0
//		{
//        didSet {
//            self.itemCount.text = String(format: "%d", self.count)
//        }
//    }
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
		let nameTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZItemStaticCell.tapGestureFromNameLabel(_:)))
		self.itemName.addGestureRecognizer(nameTap)
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
		
		cell.iconImageView.image = UIImage(named: "sakana")
        request(staticItem.image) { (image) in
            cell.iconImageView.image = image
        }

		cell.itemsize = "0"
        if let item: HDZOrder = try! HDZOrder.queries(supplierId, itemId: staticItem.id, dynamic: false) {
			if let _: Int = Int(item.size) {
				//cell.count = Int(item.size)!
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
		
		//return [[NSBundle mainBundle] loadNibNamed:className owner:self options:nil][0];
		
		let views: NSArray = NSBundle.mainBundle().loadNibNamed("HDZItemStaticCell", owner: self, options: nil)
		let cell: HDZItemStaticCell = views.firstObject as! HDZItemStaticCell;
		let height :CGFloat = cell.frame.size.height;
		
		return height;
	}

}

// MARK: - Gesture
extension HDZItemStaticCell {
	
	func openImageViewer(imageview:UIImageView) {
		
		let imageProvider = SomeImageProvider()
		let buttonAssets = CloseButtonAssets(normal: UIImage(named:"close_normal")!, highlighted: UIImage(named: "close_highlighted"))
		
		let imagesize = imageview.frame.size
		let configuration = ImageViewerConfiguration(imageSize: CGSize(width: imagesize.width, height: imagesize.height), closeButtonAssets: buttonAssets)
		
		let imageViewer = ImageViewerController(imageProvider: imageProvider, configuration: configuration, displacedView: imageview)
		self.parent.presentImageViewer(imageViewer)
	}
	
	func tapGestureFromImageView1(sender:UITapGestureRecognizer){
		openImageViewer(self.iconImageView)
	}

	func tapGestureFromNameLabel(sender:UITapGestureRecognizer){
		// TODO:商品詳細ダイアログ
		NSLog("TODO:商品詳細ダイアログ")
	}
}

// MARK: - API
extension HDZItemStaticCell {
    
    private class func request(url: NSURL, completion: (image: UIImage?) -> Void) {
        
        // 画像ローカル保存したかった。。。
        //        if let image: HDZImage = try! HDZImage.queries(url.absoluteString) {
        //            completion(image: image.image)
        //            return
        //        }
        
        let completionHandler: (Response<NSData, NSError>) -> Void = { (response: Response<NSData, NSError>) in
            if response.result.error != nil {
                //エラー処理
            } else {
                if let data: NSData = response.result.value {
                    if let resultImage: UIImage = UIImage(data: data) {
                        completion(image: resultImage)
                    }
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
            try HDZOrder.add(self.supplierId, itemId: self.staticItem.id, size: self.itemsize, name: self.staticItem.name, price: self.staticItem.price, scale: self.staticItem.scale, standard: self.staticItem.standard, imageURL: self.staticItem.image.absoluteString, dynamic: false)
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
		if (value > Int.max) {
			value = Int.max
		}
		self.itemsize = String(value)
		
//        self.count += 1
//        if self.count >= Int.max {
//            self.count = Int.max
//        }
		
        self.updateItem()
    }
    
    @IBAction func didSelectedSub(button: UIButton) {
		
		var value:Int = Int(self.itemsize)!
		value -= 1
		if (value <= 0) {
			value = 0
			self.itemsize = String(value)
			try! HDZOrder.deleteItem(self.supplierId, itemId: self.staticItem.id, dynamic: false)
		}
		else {
			self.itemsize = String(value)
			self.updateItem()
		}

//        self.count -= 1
//        if self.count <= 0 {
//            self.count = 0
//            try! HDZOrder.deleteItem(self.supplierId, itemId: self.staticItem.id, dynamic: false)
//        } else {
//            self.updateItem()
//        }
    }
}

