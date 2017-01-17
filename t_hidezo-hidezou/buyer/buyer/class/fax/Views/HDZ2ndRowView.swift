//
//  HDZ2ndRowView.swift
//  pdfsample
//
//  Created by 庄俊亮 on 2016/12/27.
//  Copyright © 2016年 庄俊亮. All rights reserved.
//

import UIKit

class HDZ2ndRowView: UIView {

	@IBOutlet weak var labelNumber: UILabel!
	@IBOutlet weak var labelProduct: UILabel!
	@IBOutlet weak var labelCount: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

	func setNumber(number:String) {
		let text:String = "（" + number + "）"
		labelNumber.text = text
	}
	
	func setProduct(name:String) {
		let text:String = name
		labelProduct.text = text
	}
	
	func setCount(count:Int) {
		let text:String = "・・・" + String(count)
		labelCount.text = text
	}
	
	func setOrderSize(orderSize:String) {
		labelCount.text = orderSize
	}
}

extension HDZ2ndRowView {
	
	internal class func createView() ->HDZ2ndRowView {
		let view:HDZ2ndRowView = HDZ2ndRowView.createView("HDZ2ndRowView")
		
		return view
	}
}
