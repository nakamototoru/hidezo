//
//  HDZOrderItemTableViewController.swift
//  seller
//
//  Created by NakaharaShun on 6/26/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZOrderItemTableViewController: UITableViewController {

    var orderDetailItem: OrderDetailItem! = nil
    
    @IBOutlet weak var codeCell: UITableViewCell!
    @IBOutlet weak var nameCell: UITableViewCell!
    @IBOutlet weak var priceCell: UITableViewCell!
    @IBOutlet weak var standardCell: UITableViewCell!
    @IBOutlet weak var scaleCell: UITableViewCell!
    @IBOutlet weak var loadingCell: UITableViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.codeCell.textLabel?.adjustsFontSizeToFitWidth = true
        self.codeCell.textLabel?.minimumScaleFactor = 0.5
        self.codeCell.textLabel?.text = self.orderDetailItem.code
        
        self.nameCell.textLabel?.adjustsFontSizeToFitWidth = true
        self.nameCell.textLabel?.minimumScaleFactor = 0.5
        self.nameCell.textLabel?.text = self.orderDetailItem.name

        self.priceCell.textLabel?.text = self.orderDetailItem.price
        self.standardCell.textLabel?.text = self.orderDetailItem.standard
        self.scaleCell.textLabel?.text = self.orderDetailItem.scale
        self.loadingCell.textLabel?.text = self.orderDetailItem.loading
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HDZOrderItemTableViewController {
    
    internal class func createViewController(orderDetailItem: OrderDetailItem) -> HDZOrderItemTableViewController {
        let controller: HDZOrderItemTableViewController = UIViewController.createViewController("HDZOrderItemTableViewController")
        controller.orderDetailItem = orderDetailItem
        return controller
    }
}
