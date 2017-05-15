//
//  MyPopupBackgroundView.swift
//  inst101
//
//  Created by 庄俊亮 on 2017/03/05.
//  Copyright © 2017年 庄俊亮. All rights reserved.
//

import UIKit

class MyPopupBackgroundView: UIView {

    override func draw(_ rect: CGRect) {
        // Drawing code

		// グラデーション
		let topColor = UIColor(hr: 0, hg: 0, hb: 0, alpha: 0.9)
		let bottomColor = UIColor(hr: 0, hg: 0, hb: 0, alpha: 0.6)
		let gradientColors:[CGColor] = [topColor.cgColor, bottomColor.cgColor]
		
		let backLayer = CAGradientLayer()
		backLayer.colors = gradientColors
		backLayer.frame = self.bounds
		
		self.layer.insertSublayer(backLayer, at: 0)
    }

}
