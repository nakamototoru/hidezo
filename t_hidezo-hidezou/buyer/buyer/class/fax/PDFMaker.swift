//
//  PDFMaker.swift
//  pdfsample
//
//  Created by 庄俊亮 on 2016/12/21.
//  Copyright © 2016年 庄俊亮. All rights reserved.
//

import UIKit

class PDFMaker: NSObject {

	static let widthApage:CGFloat = 595.0
	static let heightApage:CGFloat = 842.0

	// MARK: - http://blog.sgr-ksmt.org/2016/02/02/uiview_to_pdf/
//	private class func renderViews(views: [UIView]) {
//		guard let context = UIGraphicsGetCurrentContext() else {
//			// Not Context
//			return
//		}
//		views.forEach {
//			if let scrollView = $0 as? UIScrollView {
//				// UIScrollViewクラス継承
//				let tmpInfo = (offset: scrollView.contentOffset, frame: scrollView.frame)
//				scrollView.contentOffset = CGPoint.zero
//				scrollView.frame = CGRect(origin: CGPoint.zero, size: scrollView.contentSize)
//				UIGraphicsBeginPDFPageWithInfo(scrollView.frame, nil)
//				$0.layer.renderInContext(context)
//				scrollView.frame = tmpInfo.frame
//				scrollView.contentOffset = tmpInfo.offset
//			} else {
//				// １画面固定ビュー
//				UIGraphicsBeginPDFPageWithInfo($0.bounds, nil)
//				$0.layer.renderInContext(context)
//			}
//		}
//	}
	private class func renderViews(views:[UIView], pageRect:CGRect) {
		guard let context = UIGraphicsGetCurrentContext() else {
			// Not Context
			return
		}
		views.forEach {
			if let scrollView = $0 as? UIScrollView {
				// UIScrollViewクラス継承
				let tmpInfo = (offset: scrollView.contentOffset, frame: scrollView.frame)
				scrollView.contentOffset = CGPoint.zero
				scrollView.frame = CGRect(origin: CGPoint.zero, size: scrollView.contentSize)
				UIGraphicsBeginPDFPageWithInfo(scrollView.frame, nil)
				$0.layer.renderInContext(context)
				scrollView.frame = tmpInfo.frame
				scrollView.contentOffset = tmpInfo.offset
			} else {
				// １画面固定ビュー
				UIGraphicsBeginPDFPageWithInfo(pageRect, nil)
				$0.layer.renderInContext(context)
			}
		}		
	}
	
	class func make(views:[UIView], pageRect:CGRect) -> NSData {
		let data = NSMutableData()
		UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
		renderViews(views, pageRect: pageRect)
		UIGraphicsEndPDFContext()
		return data
	}

	// MARK: FAX送信の場合はbase64Binary変換
	internal class func makeForBase64Binary(views:[UIView], pageRect:CGRect) -> NSData {
		let data = make(views, pageRect: pageRect)
		return data.base64EncodedDataWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
	}
	internal class func makeForBase64BinaryString(views:[UIView], pageRect:CGRect) -> String {
//		let data64binary = makeForBase64Binary(views, pageRect: pageRect)
//		let str = ""+String(data:data64binary, encoding:NSUTF8StringEncoding)!
//		return str
		let data = make(views, pageRect: pageRect)
		return data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
	}
	
	internal class func makeFromViews(views:[UIView], pageRect:CGRect, fileName:String) {
		
		let pdfData = make(views, pageRect: pageRect)
		
		if let documentDirectories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first {
			let documentsFileName = documentDirectories + "/" + fileName + ".pdf"
			debugPrint(documentsFileName)
			pdfData.writeToFile(documentsFileName, atomically: true)
		}
	}
	
}
