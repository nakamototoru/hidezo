//
//  HDZTouchMarkView.swift
//  buyer
//
//  Created by 庄俊亮 on 2017/01/18.
//  Copyright © 2017年 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZTouchMarkView: UIView {

	override func draw(_ rect: CGRect) {
		// Drawing code
		let lineWidth = CGFloat(3)

		let circle = UIBezierPath(ovalIn: CGRect(
			x: lineWidth,
			y: lineWidth,
			width: rect.width - lineWidth*2,
			height: rect.height - lineWidth*2))
		
		UIColor.clear.setFill()
		circle.fill()
		UIColor.red.setStroke()
		circle.lineWidth = lineWidth
		circle.stroke()
	}

}

extension HDZTouchMarkView {
	
	internal class func createView(rect: CGRect) -> HDZTouchMarkView {
		let view = HDZTouchMarkView(frame: rect)
		view.backgroundColor = UIColor.clear
		return view
	}
	
	internal class func createView() -> HDZTouchMarkView {
		let view = HDZTouchMarkView.createView(rect: CGRect(x:0, y:0, width:80, height:80))
		//createView(CGRect(x:0, y:0, width:80, height:80))
		return view
	}
}
