//
//  HDZBadgeView.swift
//  buyer
//
//  Created by デザミ on 2016/08/29.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZBadgeView: UIView {

	var labelBadge:UILabel!
	
	
	
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

// MARK: - Create
extension HDZBadgeView {

    internal class func createWithSize(mysize:CGSize) -> HDZBadgeView {
        
        let rect:CGRect = CGRectMake(0, 0, mysize.width, mysize.height)
        let view:HDZBadgeView = HDZBadgeView(frame: rect )
        
        view.backgroundColor = UIColor.redColor()
        view.layer.cornerRadius = rect.width / 2;
        
        view.labelBadge = UILabel(frame: rect)
        view.labelBadge.textColor = UIColor.whiteColor()
        view.labelBadge.textAlignment = NSTextAlignment.Center
        view.labelBadge.font = UIFont.systemFontOfSize(rect.height * 0.8)
        
        view.addSubview(view.labelBadge)

        // 自分を隠す
        view.hidden = true
        
        return view;
    }
    
	internal class func createWithPosition(position:CGPoint, anchor:CGPoint) -> HDZBadgeView {
		
		let width:CGFloat = 20
		
		let rect:CGRect = CGRectMake(0, 0, width, width)
		let view:HDZBadgeView = HDZBadgeView(frame: rect )
		
		view.backgroundColor = UIColor.redColor()
		view.layer.cornerRadius = rect.width / 2;
		
		view.labelBadge = UILabel(frame: rect)
		view.labelBadge.textColor = UIColor.whiteColor()
		view.labelBadge.textAlignment = NSTextAlignment.Center
		view.labelBadge.font = UIFont.systemFontOfSize(rect.height * 0.8)
		
		view.addSubview(view.labelBadge)
		
		let center_x:CGFloat = position.x + (width * (0.5 - anchor.x))
		let center_y:CGFloat = position.y + (width * (0.5 - anchor.y))
		view.center = CGPointMake(center_x, center_y)
		
		// 自分を隠す
		view.hidden = true
		
		return view;
	}

}

// MARK: - Update
extension HDZBadgeView {
	
	func updateBadge(value:Int) {

		if value <= 0 {
			self.hidden = true
			return
		}
		
		self.hidden = false
		self.labelBadge.text = String(value)
	}
	
//	func hideBadge() {
//		self.hidden = true
//	}
	
}
