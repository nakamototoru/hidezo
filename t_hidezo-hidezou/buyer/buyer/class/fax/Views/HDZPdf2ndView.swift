//
//  HDZPdf2ndView.swift
//  pdfsample
//
//  Created by 庄俊亮 on 2016/12/27.
//  Copyright © 2016年 庄俊亮. All rights reserved.
//

import UIKit

class HDZPdf2ndView: UIView {

	static let maxRowCount = 26
	
	@IBOutlet weak var labelPage: UILabel!
	@IBOutlet weak var labelStore: UILabel!
	@IBOutlet weak var viewRowsBase: UIView!
	
	var rowPosY:CGFloat = 0.0
	
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

	func setPageValue(page:Int, all:Int) {
		let text:String = String(page) + "/" + String(all)
		labelPage.text = text
	}
	
	func setStoreValue(name:String, number:String) {
		let text:String = name + "（" + number + "）"
		labelStore.text = text
	}
	
//	func addRowValue(number:String, product:String, count:Int) {
//		let rowView:HDZ2ndRowView = HDZ2ndRowView.createView()
//		rowView.setNumber(number)
//		rowView.setProduct(product)
//		rowView.setCount(count)
//		rowView.frame = CGRectOffset(rowView.frame, 0, rowPosY)
//		viewRowsBase.addSubview(rowView)
//		
//		rowPosY += rowView.frame.height
//	}
	
	func addRowValue(number:String, product:String,  orderSize:String) {
		let rowView:HDZ2ndRowView = HDZ2ndRowView.createView()
		rowView.setNumber(number)
		rowView.setProduct(product)
		rowView.setOrderSize(orderSize)
		rowView.frame = CGRectOffset(rowView.frame, 0, rowPosY)
		viewRowsBase.addSubview(rowView)
		
		rowPosY += rowView.frame.height
	}
}

extension HDZPdf2ndView {
	
	internal class func createView() -> HDZPdf2ndView {
		let view:HDZPdf2ndView = createView("HDZPdf2ndView")
		return view
	}
}
