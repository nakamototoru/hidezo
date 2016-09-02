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
	private var staticItem: StaticItem!

	var parent:UIViewController!
	
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
		
		self.imageviewIcon.contentMode = UIViewContentMode.ScaleAspectFit
		
		requestImage(self.staticItem.image) { (image) in
			
			self.imageviewIcon.image = image

			//画像タップ
			let myTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZItemStaticDetailHeaderView.tapGestureFromImageView1(_:)))
			self.imageviewIcon.addGestureRecognizer(myTap)

		}
    }

}

// MARK: - Create
extension HDZItemStaticDetailHeaderView {
	
	internal class func createView(staticItem: StaticItem, parent:UIViewController) -> HDZItemStaticDetailHeaderView {
		let view: HDZItemStaticDetailHeaderView = UIView.createView("HDZItemStaticDetailHeaderView")
		view.staticItem = staticItem
		view.parent = parent
		return view
	}
}

// MARK: - API
extension HDZItemStaticDetailHeaderView {
	
	func requestImage(url: NSURL, completion: (image: UIImage?) -> Void) {
		
		#if DEBUG
			debugPrint( "HDZItemStaticDetailHeaderView:requestImage" )
			debugPrint( self.staticItem.name )
			debugPrint( url )
		#endif
		
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

// MARK: - Gesture
extension HDZItemStaticDetailHeaderView {

	func tapGestureFromImageView1(sender:UITapGestureRecognizer){
		SomeImageProvider.openImageViewer(self.imageviewIcon, controller:self.parent)
	}

}