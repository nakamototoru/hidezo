//
//  HDZItemDinamicHeaderView.swift
//  buyer
//
//  Created by NakaharaShun on 20/07/2016.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire

class HDZItemDinamicHeaderView: UIView {

    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var imageView5: UIImageView!
    @IBOutlet weak var imageView6: UIImageView!
    
    @IBOutlet weak var dateTime: UILabel!
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
                HDZItemDinamicHeaderView.request(url) { (image) in
                    imageView?.image = image
                }
            }
        }
		
		// 画像タップ
		let myTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZItemDinamicHeaderView.tapGestureFromImageView1(_:)))
		self.imageView1.addGestureRecognizer(myTap)
		let myTap2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZItemDinamicHeaderView.tapGestureFromImageView2(_:)))
		self.imageView2.addGestureRecognizer(myTap2)
		let myTap3:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZItemDinamicHeaderView.tapGestureFromImageView3(_:)))
		self.imageView3.addGestureRecognizer(myTap3)
		let myTap4:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZItemDinamicHeaderView.tapGestureFromImageView4(_:)))
		self.imageView4.addGestureRecognizer(myTap4)
		let myTap5:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZItemDinamicHeaderView.tapGestureFromImageView5(_:)))
		self.imageView5.addGestureRecognizer(myTap5)
		let myTap6:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZItemDinamicHeaderView.tapGestureFromImageView6(_:)))
		self.imageView6.addGestureRecognizer(myTap6)
		
		
		
        self.textView.text = self.dynamicItemInfo.text
        self.dateTime.text = self.dynamicItemInfo.lastUpdate.toString(NSDateFormatter(type: .DynamicDateTime))
    }
}

extension HDZItemDinamicHeaderView {
    
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

extension HDZItemDinamicHeaderView {
    
    internal class func createView(dynamicItemInfo: DynamicItemInfo) -> HDZItemDinamicHeaderView {
        let view: HDZItemDinamicHeaderView = UIView.createView("HDZItemDynamicHeaderView")
        view.dynamicItemInfo = dynamicItemInfo
        return view
    }

	internal class func createView(dynamicItemInfo: DynamicItemInfo, parent:UIViewController) -> HDZItemDinamicHeaderView {
		let view: HDZItemDinamicHeaderView = UIView.createView("HDZItemDynamicHeaderView")
		view.dynamicItemInfo = dynamicItemInfo
		view.parent = parent
		return view
	}
}

extension HDZItemDinamicHeaderView {

	func openImageViewer(imageview:UIImageView) {
		
		let imageProvider = SomeImageProvider()
		let buttonAssets = CloseButtonAssets(normal: UIImage(named:"close_normal")!, highlighted: UIImage(named: "close_highlighted"))
		
		let imagesize = imageview.frame.size
		let configuration = ImageViewerConfiguration(imageSize: CGSize(width: imagesize.width, height: imagesize.height), closeButtonAssets: buttonAssets)
		
		let imageViewer = ImageViewerController(imageProvider: imageProvider, configuration: configuration, displacedView: imageview)
		self.parent.presentImageViewer(imageViewer)
	}
	
	func tapGestureFromImageView1(sender:UITapGestureRecognizer){
		openImageViewer(self.imageView1)
	}
	func tapGestureFromImageView2(sender:UITapGestureRecognizer){
		openImageViewer(self.imageView2)
	}
	func tapGestureFromImageView3(sender:UITapGestureRecognizer){
		openImageViewer(self.imageView3)
	}
	func tapGestureFromImageView4(sender:UITapGestureRecognizer){
		openImageViewer(self.imageView4)
	}
	func tapGestureFromImageView5(sender:UITapGestureRecognizer){
		openImageViewer(self.imageView5)
	}
	func tapGestureFromImageView6(sender:UITapGestureRecognizer){
		openImageViewer(self.imageView6)
	}
}
