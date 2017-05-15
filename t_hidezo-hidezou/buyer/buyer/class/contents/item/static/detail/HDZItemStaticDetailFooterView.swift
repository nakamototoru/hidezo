//
//  HDZItemStaticDetailFooterView.swift
//  buyer
//
//  Created by デザミ on 2016/09/01.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZItemStaticDetailFooterView: UIView {


	@IBOutlet weak var textviewDetail: UITextView!
	
	var staticItem: StaticItem!

	var parent:UIViewController!

	
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
	override func draw(_ rect: CGRect) {
    //override func drawRect(rect: CGRect) {
        // Drawing code
		
		self.textviewDetail.text = self.staticItem.detail
    }

}

// MARK: - Create
extension HDZItemStaticDetailFooterView {
	
	internal class func createView(staticItem: StaticItem, parent:UIViewController) -> HDZItemStaticDetailFooterView {
		let view: HDZItemStaticDetailFooterView = UIView.createView(nibName: "HDZItemStaticDetailFooterView")
		view.staticItem = staticItem
		view.parent = parent
		return view
	}
}
