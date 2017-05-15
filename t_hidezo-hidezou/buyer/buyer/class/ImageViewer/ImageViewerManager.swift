//
//  ImageViewerManager.swift
//  buyer
//
//  Created by 庄俊亮 on 2017/05/14.
//  Copyright © 2017年 Shun Nakahara. All rights reserved.
//

import UIKit
import ImageViewer

struct ImageDataItem {
	
	let imageView: UIImageView
	let galleryItem: GalleryItem
}

class ImageViewerManager: NSObject {

	//static let shared = ImageViewerManager()
	
//	var myGalleryItem: GalleryItem?
//	var myImageView: UIImageView?
	
	var items: [ImageDataItem] = []
	
	func openImageViewer(imageView: UIImageView, controller: UIViewController) {
		
		debugPrint("TODO: ImageViewer")
		
//		guard imageView.image != nil else {
//			return
//		}
//		
//		let imageViews = [imageView]
//		
//		for (index, imageView) in imageViews.enumerated() {
//			
//			debugPrint("Imageview" + String(index))
//			//guard let imageView = imageView else { continue }
//			var galleryItem: GalleryItem!
//			
//			let image = imageView.image ?? UIImage(named: "0")!
//			galleryItem = GalleryItem.image { $0(image) }
//			
//			items.append(ImageDataItem(imageView: imageView, galleryItem: galleryItem))
//		}
//
//		let myGalleryController = GalleryViewController(startIndex: 0, itemsDataSource: self)
//		//controller.presentImageGallery(myGalleryController)
//		UIApplication.getBaseViewController()?.presentImageGallery(myGalleryController)
	}
	
}

extension ImageViewerManager: GalleryItemsDataSource {
	
	func itemCount() -> Int {
		return self.items.count
	}
	func provideGalleryItem(_ index: Int) -> GalleryItem {
		return self.items[index].galleryItem
	}
	
}
