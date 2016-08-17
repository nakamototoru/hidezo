//
//  HDZItemOrderConfirmFooter.swift
//  buyer
//
//  Created by デザミ on 2016/08/15.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit

protocol HDZItemOrderConfirmFooterDelegate: NSObjectProtocol {
	
	func didConfirmOrder()
	
}

class HDZItemOrderConfirmFooter: UIView {

	weak var delegate: HDZItemOrderConfirmFooterDelegate?

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

extension HDZItemOrderConfirmFooter {
	
	internal class func createView(controller: UIViewController, supplierId: Int, delegate: HDZItemOrderConfirmFooterDelegate) -> HDZItemOrderConfirmFooter {
		let view: HDZItemOrderConfirmFooter = UIView.createView("HDZItemOrderConfirmFooter")
//		view.supplierId = supplierId
//		view.viewController = controller
		view.delegate = delegate;
		return view
	}
}

extension HDZItemOrderConfirmFooter {
	
	@IBAction func didSelectedConfirmOrder() {
//		let controller: HDZItemCheckTableViewController = HDZItemCheckTableViewController.createViewController(self.supplierId)
//		self.viewController.navigationController?.pushViewController(controller, animated: true)
		
		self.delegate?.didConfirmOrder()
	}
}