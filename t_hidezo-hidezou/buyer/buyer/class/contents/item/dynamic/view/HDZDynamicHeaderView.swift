//
//  HDZDynamicHeaderView.swift
//  buyer
//
//  Created by デザミ on 2016/08/24.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZDynamicHeaderView: UIView {

	@IBOutlet weak var dateTime: UILabel!

	private var dynamicItemInfo: DynamicItemInfo!

//	var parent: UIViewController!

    ///*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
		
		if self.dynamicItemInfo == nil {
			return
		}

		self.dateTime.text = self.dynamicItemInfo.lastUpdate.toString(NSDateFormatter(type: .DynamicDateTime))
    }
    //*/

}

// MARK: - Create
extension HDZDynamicHeaderView {
	
	internal class func createView(dynamicItemInfo: DynamicItemInfo) -> HDZDynamicHeaderView {
		let view: HDZDynamicHeaderView = UIView.createView("HDZDynamicHeaderView")
		view.dynamicItemInfo = dynamicItemInfo
		return view
	}
	
//	internal class func createView(dynamicItemInfo: DynamicItemInfo, parent:UIViewController) -> HDZDynamicHeaderView {
//		let view: HDZDynamicHeaderView = UIView.createView("HDZDynamicHeaderView")
//		view.dynamicItemInfo = dynamicItemInfo
//		view.parent = parent
//		return view
//	}
}
