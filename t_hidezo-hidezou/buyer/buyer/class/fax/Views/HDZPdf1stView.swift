//
//  HDZPdf1stView.swift
//  pdfsample
//
//  Created by 庄俊亮 on 2016/12/24.
//  Copyright © 2016年 庄俊亮. All rights reserved.
//

import UIKit

class HDZPdf1stView: UIView {

	// MARK: - 定数
	static let maxRowCount:Int = 26	
	
	@IBOutlet weak var labelCLient: UILabel!
	@IBOutlet weak var labelPageCount: UILabel!
	@IBOutlet weak var labelOrderNumber: UILabel!
	@IBOutlet weak var labelShopName: UILabel!
	@IBOutlet weak var labelResidence: UILabel!
	@IBOutlet weak var labelOrderDate: UILabel!
	@IBOutlet weak var labelDeliveryDate: UILabel!
	
	@IBOutlet weak var viewSheetBaseLeft: UIView!
	@IBOutlet weak var viewSheetBaseRight: UIView!
	@IBOutlet weak var viewOptionBox: UIView!
	@IBOutlet weak var labelOptionNote: UILabel!
	
	
	var arrayRowView:[HDZSheetRowView] = []
	var countOfRow:Int = 0
	
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	
	func setupSheetRows() {
		// 左側
		let midasiLeft:HDZSheetMidasiView = HDZSheetMidasiView.createView()
		viewSheetBaseLeft.addSubview(midasiLeft)
		
		let rowBaseLeft0:HDZSheetRowView = HDZSheetRowView.createView()
		rowBaseLeft0.frame = CGRectOffset(rowBaseLeft0.frame, 0, midasiLeft.frame.height-1)
		viewSheetBaseLeft.addSubview(rowBaseLeft0)
		
		arrayRowView.append(rowBaseLeft0)
		
		let yNext:CGFloat = rowBaseLeft0.frame.height - 1.0
		var yPosLeft:CGFloat = rowBaseLeft0.frame.origin.y + rowBaseLeft0.frame.height - 1.0
		for _ in 0 ..< 12 {
			let rowBaseNow:HDZSheetRowView = HDZSheetRowView.createView()
			rowBaseNow.frame = CGRectOffset(rowBaseNow.frame, 0, yPosLeft)
			viewSheetBaseLeft.addSubview(rowBaseNow)
			yPosLeft += yNext
			
			arrayRowView.append(rowBaseNow)
		}
		
		// 右側
		let midasiRight:HDZSheetMidasiView = HDZSheetMidasiView.createView()
		viewSheetBaseRight.addSubview(midasiRight)

		let rowBaseRight0:HDZSheetRowView = HDZSheetRowView.createView()
		rowBaseRight0.frame = CGRectOffset(rowBaseRight0.frame, 0, midasiRight.frame.height-1)
		viewSheetBaseRight.addSubview(rowBaseRight0)
		
		arrayRowView.append(rowBaseRight0)

//		let yNext:CGFloat = rowBaseLeft0.frame.height - 1.0
		var yPosRight:CGFloat = rowBaseRight0.frame.origin.y + rowBaseRight0.frame.height - 1.0
		for _ in 0 ..< 12 {
			let rowBaseNow:HDZSheetRowView = HDZSheetRowView.createView()
			rowBaseNow.frame = CGRectOffset(rowBaseNow.frame, 0, yPosRight)
			viewSheetBaseRight.addSubview(rowBaseNow)
			yPosRight += yNext
			
			arrayRowView.append(rowBaseNow)
		}

	}
	
	func setClient(name:String) {
		let text:String = name + "御中"
		labelCLient.text = text
	}

	func setPage(now:Int, All:Int) {
		let text:String = String(now) + "枚目／" + String(All) + "枚中"
		labelPageCount.text = text
	}
	
	func setOrderNumber(number:String) {
		let text:String = "注文番号:" + number
		labelOrderNumber.text = text
	}
	
	func setShopName(name:String, number:String) {
		let text:String = "<お届け先>" + name + "(" + number + ")"
		labelShopName.text = text
	}
	
	func setResidence(address:String) {
		let text:String = "<納品住所>" + address
		labelResidence.text = text
	}
	
	func setOrderDate(date:String) {
		let text:String = "注文日時:" + date
		labelOrderDate.text = text
	}
	
	func setDeliveryDate(date:String) {
		let text:String = "納品希望日:" + date
		labelDeliveryDate.text = text
	}
	
	func setOptionNote(note:String) {
		let text:String = note
		labelOptionNote.text = text
	}
	
//	func setRowValue(index:Int, name:String, number:String, count:Int) {
//		
//		if index >= HDZPdf1stView.maxRowCount {
//			return
//		}
//		
//		let rowView:HDZSheetRowView = arrayRowView[index]
//		rowView.setProductName(name)
//		rowView.setNumber(number)
//		rowView.setCount(count)
//	}
	
//	func setRowValue(name:String, number:String, count:Int) {
//		
//		if countOfRow >= HDZPdf1stView.maxRowCount {
//			return
//		}
//		
//		setRowValue(countOfRow, name: name, number: number, count: count)
//		countOfRow += 1
//	}
	
	func setRowValue(name:String, number:String, orderSize:String) {
		
		if countOfRow >= HDZPdf1stView.maxRowCount {
			return
		}

		let rowView:HDZSheetRowView = arrayRowView[countOfRow]
		rowView.setProductName(name)
		rowView.setNumber(number)
		rowView.setOrderSize(orderSize)

		countOfRow += 1
	}
	
	func setOptionComment(comment:String) {
		
	}
}

extension HDZPdf1stView {
	
	func setupOptionBox() {
		viewOptionBox.layer.borderWidth = 2.0;
		viewOptionBox.layer.borderColor = UIColor.blackColor().CGColor
		viewOptionBox.backgroundColor = UIColor.whiteColor()
	}
	
	func setupSheetBase() {
		viewSheetBaseLeft.layer.borderWidth = 2.0
		viewSheetBaseLeft.layer.borderColor = UIColor.blackColor().CGColor
		viewSheetBaseLeft.backgroundColor = UIColor.whiteColor()
		
		viewSheetBaseRight.layer.borderWidth = 2.0
		viewSheetBaseRight.layer.borderColor = UIColor.blackColor().CGColor
		viewSheetBaseRight.backgroundColor = UIColor.whiteColor()
	}

	internal class func createView() -> HDZPdf1stView {
		let view:HDZPdf1stView = HDZPdf1stView.createView("HDZPdf1stView")
		view.setupOptionBox()
		view.setupSheetBase()
		return view
	}
}
