//
//  HDZItemCheckOrderFooter.swift
//  buyer
//
//  Created by Shun Nakahara on 8/1/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZItemCheckOrderFooter: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var supplierId: Int = 0

    var viewController: UIViewController!
    
}

extension HDZItemCheckOrderFooter {
    
    internal class func createView(controller: UIViewController, supplierId: Int) -> HDZItemCheckOrderFooter {
        let view: HDZItemCheckOrderFooter = UIView.createView("HDZItemCheckOrderFooter")
        view.supplierId = supplierId
        view.viewController = controller
        return view
    }
}

extension HDZItemCheckOrderFooter {
    
    @IBAction func didSelectedCheckOrder() {
        let controller: HDZItemCheckTableViewController = HDZItemCheckTableViewController.createViewController(self.supplierId)
        self.viewController.navigationController?.pushViewController(controller, animated: true)
    }
}
