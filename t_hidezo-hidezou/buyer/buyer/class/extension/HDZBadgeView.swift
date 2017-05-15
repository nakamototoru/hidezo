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
        
		let rect:CGRect = CGRect(x: 0, y: 0, width: mysize.width, height: mysize.height)
        let view:HDZBadgeView = HDZBadgeView(frame: rect )
        
        view.backgroundColor = UIColor.red
        view.layer.cornerRadius = rect.width / 2;
        
        view.labelBadge = UILabel(frame: rect)
        view.labelBadge.textColor = UIColor.white
        view.labelBadge.textAlignment = NSTextAlignment.center
		view.labelBadge.font = UIFont.systemFont(ofSize: rect.height * 0.8)
        
        view.addSubview(view.labelBadge)

        // 自分を隠す
        view.isHidden = true
        
        return view;
    }
    
	internal class func createWithPosition(position:CGPoint, anchor:CGPoint) -> HDZBadgeView {
		
		let width:CGFloat = 20
		
		let rect:CGRect = CGRect(x: 0, y: 0, width: width, height: width)
		let view:HDZBadgeView = HDZBadgeView(frame: rect )
		
		view.backgroundColor = UIColor.red
		view.layer.cornerRadius = rect.width / 2;
		
		view.labelBadge = UILabel(frame: rect)
		view.labelBadge.textColor = UIColor.white
		view.labelBadge.textAlignment = NSTextAlignment.center
		view.labelBadge.font = UIFont.systemFont(ofSize: rect.height * 0.8)
		
		view.addSubview(view.labelBadge)
		
		let center_x:CGFloat = position.x + (width * (0.5 - anchor.x))
		let center_y:CGFloat = position.y + (width * (0.5 - anchor.y))
		view.center = CGPoint(x: center_x, y: center_y)
		
		// 自分を隠す
		view.isHidden = true
		
		return view;
	}

}

// MARK: - Update
extension HDZBadgeView {
	
	func updateBadge(value:Int) {

		if value <= 0 {
			self.isHidden = true
			return
		}
		
		self.isHidden = false
		self.labelBadge.text = String(value)
	}

}
