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
		
		let indicatorView:CustomIndicatorView = CustomIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
		indicatorView.color = UIColor.black
		indicatorView.frame = CGRect(x: 0, y: 0, width: 160, height: 160)
		indicatorView.center = CGPoint(x: framesize.width/2, y: framesize.height/8)

		return indicatorView
	}
}
