//
//  UIColor_Extension.swift
//  
//
//  Created by 庄俊亮 on 2017/03/04.
//
//

import UIKit

extension UIColor {
	
	// HTML書式
	convenience init(hex: Int, alpha: Double = 1.0) {
		let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
		let g = CGFloat((hex & 0x00FF00) >> 8) / 255.0
		let b = CGFloat(hex & 0x0000FF) / 255.0
		self.init(red: r, green: g, blue: b, alpha: CGFloat(alpha))
	}
	
	// 整数(0~255,0x00~0xFF)指定
	convenience init(hr: Int, hg: Int, hb: Int, alpha: Double = 1.0) {
		let r = CGFloat(hr) / 255.0
		let g = CGFloat(hg) / 255.0
		let b = CGFloat(hb) / 255.0
		self.init(red: r, green: g, blue: b, alpha: CGFloat(alpha))
	}
}
