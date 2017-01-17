//
//  HDZSheetMidasiView.swift
//  pdfsample
//
//  Created by 庄俊亮 on 2016/12/25.
//  Copyright © 2016年 庄俊亮. All rights reserved.
//

import UIKit

class HDZSheetMidasiView: UIView {

	@IBOutlet weak var viewProductNameBase: UIView!
	@IBOutlet weak var viewNumberBase: UIView!
	@IBOutlet weak var viewCountBase: UIView!
	
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

	func setupBase() {
		viewProductNameBase.layer.borderWidth = 1.0
		viewProductNameBase.layer.borderColor = UIColor.blackColor().CGColor
		
		viewNumberBase.layer.borderWidth = 1.0
		viewNumberBase.layer.borderColor = UIColor.blackColor().CGColor
		
		viewCountBase.layer.borderWidth = 1.0
		viewCountBase.layer.borderColor = UIColor.blackColor().CGColor
	}
}

extension HDZSheetMidasiView {
	
	internal class func createView() -> HDZSheetMidasiView {
		let view:HDZSheetMidasiView = HDZSheetMidasiView.createView("HDZSheetMidasiView")
		view.setupBase()
		return view
	}
}
