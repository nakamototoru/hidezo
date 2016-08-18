//
//  SomeImageProvider.swift
//  buyer
//
//  Created by デザミ on 2016/08/18.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit

class SomeImageProvider: ImageProvider {

	let images = [
		UIImage(named: "sakana"),
		UIImage(named: "Appicon")]
	
	var imageCount: Int {
		return images.count
	}
	
	func provideImage(completion: UIImage? -> Void) {
		//completion(UIImage(named: "image_big"))
	}
	
	func provideImage(atIndex index: Int, completion: UIImage? -> Void) {
		//completion(images[index])
	}

}
