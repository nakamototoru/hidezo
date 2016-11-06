//
//  CustomIndicatorView.swift
//  buyer
//
//  Created by デザミ on 2016/08/25.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit

class CustomIndicatorView: UIActivityIndicatorView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

// MARK: - Create
extension CustomIndicatorView {

	internal class func createView(framesize:CGSize) -> CustomIndicatorView {
		
		let indicatorView:CustomIndicatorView = CustomIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
		indicatorView.color = UIColor.blackColor()
		indicatorView.frame = CGRectMake(0, 0, 160, 160)
		indicatorView.center = CGPointMake(framesize.width/2, framesize.height/8)

		return indicatorView
	}
}
