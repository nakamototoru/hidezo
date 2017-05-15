//
//  HDZItemStaticDetailHeaderView.swift
//  buyer
//
//  Created by デザミ on 2016/08/25.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire

class HDZItemStaticDetailHeaderView: UIView {

	@IBOutlet weak var imageviewIcon: UIImageView!
	
	// 対象商品
	var staticItem: StaticItem!

	var parent:UIViewController!
	
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
		
		self.imageviewIcon.contentMode = UIViewContentMode.scaleAspectFit
		
		requestImage(url: self.staticItem.image) { (image) in
			
			self.imageviewIcon.image = image

			//画像タップ
			let myTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZItemStaticDetailHeaderView.tapGestureFromImageView1))
			self.imageviewIcon.addGestureRecognizer(myTap)

		}
    }

}

// MARK: - Create
extension HDZItemStaticDetailHeaderView {
	
	internal class func createView(staticItem: StaticItem, parent:UIViewController) -> HDZItemStaticDetailHeaderView {
		let view: HDZItemStaticDetailHeaderView = UIView.createView(nibName: "HDZItemStaticDetailHeaderView")
		view.staticItem = staticItem
		view.parent = parent
		return view
	}
}

// MARK: - API
extension HDZItemStaticDetailHeaderView {
	
	func requestImage(url: URL, completion: @escaping (_ image: UIImage?) -> Void) {
		
		#if DEBUG
			debugPrint( "HDZItemStaticDetailHeaderView:requestImage" )
			debugPrint( self.staticItem.name )
			debugPrint( url )
		#endif
		
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
			if let resultImage: UIImage = UIImage(data: value) {
				completion(resultImage)
			}
			else {
				let sakanaimage:UIImage = UIImage(named: "sakana")!
				completion(sakanaimage)
			}
		}) { error in
			let sakanaimage:UIImage = UIImage(named: "sakana")!
			completion(sakanaimage)
		}
	}
}

// MARK: - Gesture
extension HDZItemStaticDetailHeaderView {

	func tapGestureFromImageView1(sender:UITapGestureRecognizer){
		//SomeImageProvider.openImageViewer(imageview: self.imageviewIcon, controller:self.parent)
		let viewer = ImageViewerManager()
		viewer.openImageViewer(imageView: self.imageviewIcon, controller: self.parent)
	}

}
