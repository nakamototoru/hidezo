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

	var parent:UIViewController!
	
    private var staticItem: StaticItem!
    private var attr_flg: AttrFlg = AttrFlg.direct
    private var supplierId: Int = 0

    private var count: Int = 0 {
        didSet {
            self.itemCount.text = String(format: "%d", self.count)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		//画像タップ
		let myTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZItemDinamicHeaderView.tapGestureFromImageView1(_:)))
		self.iconImageView.addGestureRecognizer(myTap)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

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
        
        request(staticItem.image) { (image) in
            cell.iconImageView.image = image
        }

        if let item: HDZOrder = try! HDZOrder.queries(supplierId, itemId: staticItem.id, dynamic: false) {
            cell.count = item.size
        } else {
            cell.count = 0
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

}

extension HDZItemStaticCell {
    
    private class func request(url: NSURL, completion: (image: UIImage?) -> Void) {
        
        // 画像ローカル保存したかった。。。
        //        if let image: HDZImage = try! HDZImage.queries(url.absoluteString) {
        //            completion(image: image.image)
        //            return
        //        }
        
        let completionHandler: (Response<NSData, NSError>) -> Void = { (response: Response<NSData, NSError>) in
            if response.result.error != nil {
                
            } else {
                if let data: NSData = response.result.value {
                    
                    //                    try! HDZImage.add(url.absoluteString, data: data)
                    
                    if let resultImage: UIImage = UIImage(data: data) {
                        completion(image: resultImage)
                    }
                }
            }
        }
        let _: Alamofire.Request? = Alamofire.request(.GET, url).responseData(completionHandler: completionHandler)
    }
}

extension HDZItemStaticCell {
    
    private func updateItem() {
        
        do {
            try HDZOrder.add(self.supplierId, itemId: self.staticItem.id, size: self.count, name: self.staticItem.name, price: self.staticItem.price, scale: self.staticItem.scale, standard: self.staticItem.standard, imageURL: self.staticItem.image.absoluteString, dynamic: false)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
}

extension HDZItemStaticCell {
    
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
            try! HDZOrder.deleteItem(self.supplierId, itemId: self.staticItem.id, dynamic: false)
        } else {
            self.updateItem()
        }
    }
}
