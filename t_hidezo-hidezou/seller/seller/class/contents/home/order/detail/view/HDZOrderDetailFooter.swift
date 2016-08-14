//
//  HDZOrderDetailFooter.swift
//  seller
//
//  Created by NakaharaShun on 6/25/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit

protocol HDZOrderDetailFooterDelegate: NSObjectProtocol {
    func didSelected(param: OrderDetailFooterParam)
}

class OrderDetailFooterParam {
    
    var subTotal: Int = 0
    var postage: Int = 0
    var total: Int = 0
    var charge: String = ""
    var delivered: String = ""
    var deliveredPlace: String = ""
}

class HDZOrderDetailFooter: UIView {

    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var postageLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var chargeLabel: UILabel!
    @IBOutlet weak var deliveredLabel: UILabel!
    @IBOutlet weak var deliveredPlaceLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    private lazy var orderDetailItems: [OrderDetailItem] = []
    private lazy var param: OrderDetailFooterParam = OrderDetailFooterParam()
    private lazy var deliverToList: [String] = []
    private var attr_flg: AttrFlg = AttrFlg.direct
    
    private weak var delegate: HDZOrderDetailFooterDelegate?
    
    private var viewController: HDZOrderDetailTableViewController!
	
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        self.submitButton.layer.cornerRadius = 5.0

        
        if self.orderDetailItems.count > 0 {
            var total: Int = 0
            var subTotal: Int = 0
            
            for item: OrderDetailItem in self.orderDetailItems {
                let price: Int = HDZOrderDetailCell.priceValue(item.price, order_num: item.order_num, attr_flg: self.attr_flg)
                subTotal += price
            }
            
            total = subTotal + self.param.postage
            
            self.param.subTotal = subTotal
            self.param.total = total
            
            self.updateParams()
        }
        
        self.deliveredPlaceLabel.layer.borderWidth = 1.0
        self.deliveredPlaceLabel.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.deliveredPlaceLabel.layer.cornerRadius = 5.0
        
        self.deliveredLabel.layer.borderWidth = 1.0
        self.deliveredLabel.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.deliveredLabel.layer.cornerRadius = 5.0
        
        let tapPlaceGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZOrderDetailFooter.didSelectedOrderTo))
        self.deliveredPlaceLabel.addGestureRecognizer(tapPlaceGestureRecognizer)

        let tapDateGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZOrderDetailFooter.didSelectedDeliverdDate(_:))) // tapGestureRecognizer
        self.deliveredLabel.addGestureRecognizer(tapDateGestureRecognizer)
    }
}

extension HDZOrderDetailFooter {
    
    internal func setResult(result: OrderDetailFooterParam) {
        self.param = result
        self.updateParams()
    }
}

// MARK: - static
extension HDZOrderDetailFooter {
    
    internal class func createView(controller: HDZOrderDetailTableViewController, delegate: HDZOrderDetailFooterDelegate, result: OrderDetailResult!, orderDetailItems: [OrderDetailItem]) -> HDZOrderDetailFooter {
        let footer: HDZOrderDetailFooter = UIView.createView("HDZOrderDetailFooter")

        footer.attr_flg = result.attr_flg
        footer.deliverToList = result.deliver_to_list
        
        footer.param.charge = result.charge
        footer.param.postage = result.deliveryFee
        footer.param.total = result.total
        footer.param.delivered = result.delivery_day
        footer.param.deliveredPlace = result.deliver_to
        footer.param.subTotal = result.subtotal

        footer.orderDetailItems = orderDetailItems
        footer.delegate = delegate
        footer.viewController = controller
        footer.updateParams()

        return footer
    }
}

// MARK: - action
extension HDZOrderDetailFooter {

    @IBAction func didSelectedEdit(sender: UIButton) {
        self.delegate?.didSelected(self.param)
    }
    
    func didSelectedOrderTo() {
        let controller: HDZOrderToViewController = HDZOrderToViewController.createViewController(self.deliveredPlaceLabel.text, deliverToList: self.deliverToList, delegate: self)
        self.viewController.presentViewController(controller, animated: true, completion: nil)
    }
    
    func didSelectedDeliverdDate(tapGestureRecognizer: UITapGestureRecognizer) {
        
        let controller: HDZOrderDateViewController = HDZOrderDateViewController.createViewController(tapGestureRecognizer.view, delegate: self, presentDelegate: self.viewController)
        self.viewController.presentViewController(controller, animated: true, completion: nil)
    }
}

// MARK: - private
extension HDZOrderDetailFooter {
    
    private func updateParams() {
        self.chargeLabel.text = self.param.charge
        self.deliveredLabel.text = self.param.delivered
        self.deliveredPlaceLabel.text = self.param.deliveredPlace
        self.postageLabel.text = String(format: "%d円", self.param.postage)
        self.subtotalLabel.text = String(format: "%d円", self.param.subTotal)
        self.totalLabel.text = String(format: "%d円", self.param.total)
    }
}

// MARK: - 
extension HDZOrderDetailFooter: HDZOrderToViewControllerDeegate {
    
    func didSelectedPlace(place: String?) {
        self.deliveredPlaceLabel.text = place
        if let value: String = place {
            self.param.deliveredPlace = value
        }
    }
}

extension HDZOrderDetailFooter: HDZOrderDateViewControllerDelegate {
    
    func didSelectedDate(dateString: String?) {
        self.deliveredLabel.text = dateString
        if let value: String = dateString {
            self.param.delivered = value
        }
    }
}

