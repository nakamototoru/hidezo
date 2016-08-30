//
//  HDZOrderDetailFooter.swift
//  seller
//
//  Created by NakaharaShun on 6/25/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit

protocol HDZOrderDetailFooterDelegate {
    func didSelected()
}

struct OrderDetailFooterParam {
//    let subTotal = value
    
}

class HDZOrderDetailFooter: UIView {

    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var postageLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var chargeLabel: UILabel!
    @IBOutlet weak var deliveredLabel: UILabel!
    @IBOutlet weak var deliveredPlaceLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        self.submitButton.layer.cornerRadius = 5.0
    }
}

extension HDZOrderDetailFooter {
    
}

// MARK: - static
extension HDZOrderDetailFooter {
    
    internal class func createView() -> HDZOrderDetailFooter {
        let footer: HDZOrderDetailFooter = UIView.createView("HDZOrderDetailFooter")
        return footer
    }
}

// MARK: - action
extension HDZOrderDetailFooter {

    @IBAction func didSelectedEdit(sender: UIButton) {
        debugPrint("--------------------")
    }
}

