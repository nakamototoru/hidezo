//
//  SomeImageProvider.swift
//  buyer
//
//  Created by デザミ on 2016/08/18.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit
import ImageViewer

struct DataItem {
	
	let imageView: UIImageView
	let galleryItem: GalleryItem
}

class SomeImageProvider: ImageProvider {

	var items: [DataItem] = []
	
	let images = [
		UIImage(named: "sakana"),
		UIImage(named: "Appicon")]
	
	var imageCount: Int {
		return images.count
	}
	
	func provideImage(completion: (UIImage?) -> Void) {
		//completion(UIImage(named: "image_big"))
	}
	
	func provideImage(atIndex index: Int, completion: (UIImage?) -> Void) {
		//completion(images[index])
	}

}

extension SomeImageProvider {
	
	// 直接指定
	internal class func openImageViewer(imageview:UIImageView, controller:UIViewController) {
		
//		let imageProvider = SomeImageProvider()
//		let buttonAssets = CloseButtonAssets(normal: UIImage(named:"close_normal")!, highlighted: UIImage(named: "close_highlighted"))
//		
//		let imagesize = imageview.frame.size
//		let configuration = ImageViewerConfiguration(imageSize: CGSize(width: imagesize.width, height: imagesize.height), closeButtonAssets: buttonAssets)
//		
//		let imageViewer = ImageViewerController(imageProvider: imageProvider, configuration: configuration, displacedView: imageview)
//		controller.presentImageViewer(imageViewer: imageViewer)
		
		// New
		//let galleryViewController = GalleryViewController(startIndex: displacedViewIndex, itemsDataSource: self, itemsDelegate: self, displacedViewsDataSource: self, configuration: galleryConfiguration())

		let gallery = GalleryViewController(startIndex: 0, itemsDataSource: self as! GalleryItemsDataSource)
	}

}

extension SomeImageProvider: GalleryItemsDataSource {
	
	func itemCount() -> Int {
		
		return items.count
	}
	
	func provideGalleryItem(_ index: Int) -> GalleryItem {
		
		return items[index].galleryItem
	}
}
