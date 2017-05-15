
//
//  HDZItemDynamicFooterView.swift
//  buyer
//
//  Created by デザミ on 2016/08/24.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire
import ImageViewer

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
	
	var dynamicItemInfo: DynamicItemInfo!

	// Only override draw() if you perform custom drawing.
	// An empty implementation adversely affects performance during animation.
	override func draw(_ rect: CGRect) {
		// Drawing code
		
		if self.dynamicItemInfo == nil {
			return
		}
		
		self.imageView1.contentMode = UIViewContentMode.scaleAspectFit
		self.imageView2.contentMode = UIViewContentMode.scaleAspectFit
		self.imageView3.contentMode = UIViewContentMode.scaleAspectFit
		self.imageView4.contentMode = UIViewContentMode.scaleAspectFit
		self.imageView5.contentMode = UIViewContentMode.scaleAspectFit
		self.imageView6.contentMode = UIViewContentMode.scaleAspectFit
		
		// 画像取得
		for imagePath in self.dynamicItemInfo.imagePath.enumerated() {
			var imageView: UIImageView? = nil
			switch imagePath.offset {
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
			
			guard imageView != nil else {
				continue
			}
			
			if let url = URL(string: imagePath.element) {
				HDZItemDynamicFooterView.requestImage(url: url) { (image) in
					imageView?.image = image
				}
			}
		}
		
		// 画像タップ
		let myTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZItemDynamicFooterView.tapGestureFromImageView1))
		self.imageView1.addGestureRecognizer(myTap)
		let myTap2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZItemDynamicFooterView.tapGestureFromImageView2))
		self.imageView2.addGestureRecognizer(myTap2)
		let myTap3:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZItemDynamicFooterView.tapGestureFromImageView3))
		self.imageView3.addGestureRecognizer(myTap3)
		let myTap4:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZItemDynamicFooterView.tapGestureFromImageView4))
		self.imageView4.addGestureRecognizer(myTap4)
		let myTap5:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZItemDynamicFooterView.tapGestureFromImageView5))
		self.imageView5.addGestureRecognizer(myTap5)
		let myTap6:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZItemDynamicFooterView.tapGestureFromImageView6))
		self.imageView6.addGestureRecognizer(myTap6)
		
		//説明文
		self.textView.text = self.dynamicItemInfo.text
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
		let view: HDZItemDynamicFooterView = UIView.createView(nibName: "HDZItemDynamicFooterView")
		view.dynamicItemInfo = dynamicItemInfo
		view.parent = parent
		return view
	}
}

// MARK: - API
extension HDZItemDynamicFooterView {
	
	class func requestImage(url: URL, completion: @escaping (_ image: UIImage?) -> Void) {
		
		// 画像ローカル保存したかった。。。
		//        if let image: HDZImage = try! HDZImage.queries(url.absoluteString) {
		//            completion(image: image.image)
		//            return
		//        }
		
//		let completionHandler: (Response<NSData, NSError>) -> Void = { (response: Response<NSData, NSError>) in
//			if response.result.error != nil {
//				let sakanaimage:UIImage = UIImage(named: "sakana")!
//				completion(image: sakanaimage)
//			}
//			else {
//				if let data: NSData = response.result.value {
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
		
		//let _: Alamofire.Request? = Alamofire.request(.GET, url).responseData(completionHandler: completionHandler)
		let _ = AlamofireManager.requestData(url: url, success: { value in
			if let resultImage = UIImage(data: value) {
				completion(resultImage)
			}
			else {
				
				debugPrint("requestData -> Null")

				let sakanaimage = UIImage(named: "sakana")!
				completion(sakanaimage)
			}
		}) { error in
			
			debugPrint("requestData -> ERROR")
			
			let sakanaimage = UIImage(named: "sakana")!
			completion(sakanaimage)
		}
		
	}
}

// MARK: - ImageView
extension HDZItemDynamicFooterView {
	
	func openImageViewer(imageview:UIImageView) {
		
//		let imageProvider = SomeImageProvider()
//		let buttonAssets = CloseButtonAssets(normal: UIImage(named:"close_normal")!, highlighted: UIImage(named: "close_highlighted"))
//		
//		let imagesize = imageview.frame.size
//		let configuration = ImageViewerConfiguration(imageSize: CGSize(width: imagesize.width, height: imagesize.height), closeButtonAssets: buttonAssets)
//		
//		let imageViewer = ImageViewerController(imageProvider: imageProvider, configuration: configuration, displacedView: imageview)
//		self.parent.presentImageViewer(imageViewer: imageViewer)
		

		let viewer = ImageViewerManager()
		viewer.openImageViewer(imageView: imageview, controller: self.parent)
	}
	
	func tapGestureFromImageView1(sender:UITapGestureRecognizer){
		
		if self.dynamicItemInfo.imagePath.count < 1 {
			return;
		}
		
		openImageViewer(imageview: self.imageView1)
	}
	func tapGestureFromImageView2(sender:UITapGestureRecognizer){
		
		if self.dynamicItemInfo.imagePath.count < 2 {
			return;
		}
		
		openImageViewer(imageview: self.imageView2)
	}
	func tapGestureFromImageView3(sender:UITapGestureRecognizer){
		
		if self.dynamicItemInfo.imagePath.count < 3 {
			return;
		}
		
		openImageViewer(imageview: self.imageView3)
	}
	func tapGestureFromImageView4(sender:UITapGestureRecognizer){
		
		if self.dynamicItemInfo.imagePath.count < 4 {
			return;
		}
		
		openImageViewer(imageview: self.imageView4)
	}
	func tapGestureFromImageView5(sender:UITapGestureRecognizer){
		
		if self.dynamicItemInfo.imagePath.count < 5 {
			return;
		}
		
		openImageViewer(imageview: self.imageView5)
	}
	func tapGestureFromImageView6(sender:UITapGestureRecognizer){
		
		if self.dynamicItemInfo.imagePath.count < 6 {
			return;
		}
		
		openImageViewer(imageview: self.imageView6)
	}
}
