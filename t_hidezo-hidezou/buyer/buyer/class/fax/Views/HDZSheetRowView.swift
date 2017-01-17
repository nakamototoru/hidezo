//
//  HDZSheetRowView.swift
//  pdfsample
//
//  Created by 庄俊亮 on 2016/12/26.
//  Copyright © 2016年 庄俊亮. All rights reserved.
//

import UIKit

class HDZSheetRowView: UIView {

	@IBOutlet weak var viewProductNameBase: UIView!
	@IBOutlet weak var viewNumberBase: UIView!
	@IBOutlet weak var viewCountBase: UIView!
	@IBOutlet weak var labelProductName: UILabel!
	@IBOutlet weak var labelNumber: UILabel!
	@IBOutlet weak var labelCount: UILabel!
	
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	
	func setProductName(name:String) {
		let text:String = name
		labelProductName.text = text
	}
	
	func setNumber(number:String) {
		let text:String = number
		labelNumber.text = text
	}
	
	func setCount(count:Int) {
		let text:String = String(count)
		labelCount.text = text
	}
	
	func setOrderSize(orderSize:String) {
		labelCount.text = orderSize
	}
}

extension HDZSheetRowView {
	
	func setupBase() {
		viewProductNameBase.layer.borderColor = UIColor.blackColor().CGColor
		viewProductNameBase.layer.borderWidth = 1.0
		
		viewNumberBase.layer.borderColor = UIColor.blackColor().CGColor
		viewNumberBase.layer.borderWidth = 1.0
		
		viewCountBase.layer.borderColor = UIColor.blackColor().CGColor
		viewCountBase.layer.borderWidth = 1.0
		
		labelProductName.text = ""
		labelNumber.text = ""
		labelCount.text = ""
	}

	internal class func createView() -> HDZSheetRowView {
		let view:HDZSheetRowView = HDZSheetRowView.createView("HDZSheetRowView")
		view.setupBase()
		return view
	}
}
