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
}
