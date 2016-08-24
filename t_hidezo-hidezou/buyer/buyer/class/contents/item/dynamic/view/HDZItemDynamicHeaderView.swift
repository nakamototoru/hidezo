//
//  HDZItemDynamicHeaderView.swift
//  buyer
//
//  Created by デザミ on 2016/08/24.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire

class HDZItemDynamicHeaderView: UIView {

	@IBOutlet weak var dateTime: UILabel!

	private var dynamicItemInfo: DynamicItemInfo!

	
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
		if self.dynamicItemInfo == nil {
			return
		}

		self.dateTime.text = self.dynamicItemInfo.lastUpdate.toString(NSDateFormatter(type: .DynamicDateTime))
    }
}

// MARK: - Create
extension HDZItemDynamicHeaderView {
	
	internal class func createView(dynamicItemInfo: DynamicItemInfo) -> HDZItemDynamicHeaderView {
		let view: HDZItemDynamicHeaderView = UIView.createView("HDZItemDynamicHeaderView")
		view.dynamicItemInfo = dynamicItemInfo
		return view
	}
}
