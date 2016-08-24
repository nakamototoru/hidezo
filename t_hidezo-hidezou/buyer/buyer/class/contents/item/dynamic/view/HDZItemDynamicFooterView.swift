//
//  HDZItemDynamicFooterView.swift
//  buyer
//
//  Created by デザミ on 2016/08/24.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire

class HDZItemDynamicFooterView: UIView {

	@IBOutlet weak var imageView1: UIImageView!
	@IBOutlet weak var imageView2: UIImageView!
	@IBOutlet weak var imageView3: UIImageView!
	@IBOutlet weak var imageView4: UIImageView!
	@IBOutlet weak var imageView5: UIImageView!
	@IBOutlet weak var imageView6: UIImageView!
	
//	@IBOutlet weak var dateTime: UILabel!
	@IBOutlet weak var textView: UITextView!
	
	var parent: UIViewController!
	
	private var dynamicItemInfo: DynamicItemInfo!

	// Only override draw() if you perform custom drawing.
	// An empty implementation adversely affects performance during animation.
	override func drawRect(rect: CGRect) {
		// Drawing code
		
		if self.dynamicItemInfo == nil {
			return
		}
		
		for imagePath in self.dynamicItemInfo.imagePath.enumerate() {
			var imageView: UIImageView? = nil
			switch imagePath.index {
			case 0:
				imageView = self.imageView1
			case 1:
				imageView = self.imageView2
			case 2:
				imageView = self.imageView3
			case 3:
				imageView = self.imageView4
			case 4:
				imageView = self.imageView5
			case 5:
				imageView = self.imageView6
			default:
				imageView = nil
			}
			
			if let url: NSURL = NSURL(string: imagePath.element) {
				HDZItemDynamicFooterView.request(url) { (image) in
					imageView?.image = image
				}
			}
		}
		
		// 画像タップ
		let myTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZItemDynamicFooterView.tapGestureFromImageView1(_:)))
		self.imageView1.addGestureRecognizer(myTap)
		let myTap2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZItemDynamicFooterView.tapGestureFromImageView2(_:)))
		self.imageView2.addGestureRecognizer(myTap2)
		let myTap3:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZItemDynamicFooterView.tapGestureFromImageView3(_:)))
		self.imageView3.addGestureRecognizer(myTap3)
		let myTap4:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZItemDynamicFooterView.tapGestureFromImageView4(_:)))
		self.imageView4.addGestureRecognizer(myTap4)
		let myTap5:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZItemDynamicFooterView.tapGestureFromImageView5(_:)))
		self.imageView5.addGestureRecognizer(myTap5)
		let myTap6:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZItemDynamicFooterView.tapGestureFromImageView6(_:)))
		self.imageView6.addGestureRecognizer(myTap6)
		
		//説明文
		self.textView.text = self.dynamicItemInfo.text
		
//		self.dateTime.text = self.dynamicItemInfo.lastUpdate.toString(NSDateFormatter(type: .DynamicDateTime))
	}

}

// MARK: - Create
extension HDZItemDynamicFooterView {
	
//	internal class func createView(dynamicItemInfo: DynamicItemInfo) -> HDZItemDynamicFooterView {
//		let view: HDZItemDynamicFooterView = UIView.createView("HDZItemDynamicFooterView")
//		view.dynamicItemInfo = dynamicItemInfo
//		return view
//	}
	
	internal class func createView(dynamicItemInfo: DynamicItemInfo, parent:UIViewController) -> HDZItemDynamicFooterView {
		let view: HDZItemDynamicFooterView = UIView.createView("HDZItemDynamicFooterView")
		view.dynamicItemInfo = dynamicItemInfo
		view.parent = parent
		return view
	}
}

// MARK: - API
extension HDZItemDynamicFooterView {
	
	private class func request(url: NSURL, completion: (image: UIImage?) -> Void) {
		
		// 画像ローカル保存したかった。。。
		//        if let image: HDZImage = try! HDZImage.queries(url.absoluteString) {
		//            completion(image: image.image)
		//            return
		//        }
		
		let completionHandler: (Response<NSData, NSError>) -> Void = { (response: Response<NSData, NSError>) in
			if response.result.error != nil {
				let sakanaimage:UIImage = UIImage(named: "sakana")!
				completion(image: sakanaimage)
			}
			else {
				if let data: NSData = response.result.value {
					if let resultImage: UIImage = UIImage(data: data) {
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

// MARK: - ImageView
extension HDZItemDynamicFooterView {
	
	func openImageViewer(imageview:UIImageView) {
		
		let imageProvider = SomeImageProvider()
		let buttonAssets = CloseButtonAssets(normal: UIImage(named:"close_normal")!, highlighted: UIImage(named: "close_highlighted"))
		
		let imagesize = imageview.frame.size
		let configuration = ImageViewerConfiguration(imageSize: CGSize(width: imagesize.width, height: imagesize.height), closeButtonAssets: buttonAssets)
		
		let imageViewer = ImageViewerController(imageProvider: imageProvider, configuration: configuration, displacedView: imageview)
		self.parent.presentImageViewer(imageViewer)
	}
	
	func tapGestureFromImageView1(sender:UITapGestureRecognizer){
		
		if self.dynamicItemInfo.imagePath.count < 1 {
			return;
		}
		
		openImageViewer(self.imageView1)
	}
	func tapGestureFromImageView2(sender:UITapGestureRecognizer){
		
		if self.dynamicItemInfo.imagePath.count < 2 {
			return;
		}
		
		openImageViewer(self.imageView2)
	}
	func tapGestureFromImageView3(sender:UITapGestureRecognizer){
		
		if self.dynamicItemInfo.imagePath.count < 3 {
			return;
		}
		
		openImageViewer(self.imageView3)
	}
	func tapGestureFromImageView4(sender:UITapGestureRecognizer){
		
		if self.dynamicItemInfo.imagePath.count < 4 {
			return;
		}
		
		openImageViewer(self.imageView4)
	}
	func tapGestureFromImageView5(sender:UITapGestureRecognizer){
		
		if self.dynamicItemInfo.imagePath.count < 5 {
			return;
		}
		
		openImageViewer(self.imageView5)
	}
	func tapGestureFromImageView6(sender:UITapGestureRecognizer){
		
		if self.dynamicItemInfo.imagePath.count < 6 {
			return;
		}
		
		openImageViewer(self.imageView6)
	}
}
