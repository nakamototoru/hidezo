//
//  HDZItemCheckCell.swift
//  buyer
//
//  Created by Shun Nakahara on 8/1/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit

protocol HDZItemCheckCellDelegate: NSObjectProtocol {
    
    func didSelectedDeleted()
    
}

class HDZItemCheckCell: UITableViewCell {

    
    @IBOutlet weak var indexText: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var sizeLabel: UILabel!
    
    var order: HDZOrder! = nil
    weak var delegate: HDZItemCheckCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension HDZItemCheckCell {
    
    internal class func register(tableView: UITableView) {
        let bundle: NSBundle = NSBundle.mainBundle()
        let nib: UINib = UINib(nibName: "HDZItemCheckCell", bundle: bundle)
        tableView.registerNib(nib, forCellReuseIdentifier: "HDZItemCheckCell")
    }

    internal class func dequeueReusableCell(tableView: UITableView, indexPath: NSIndexPath, delegate: HDZItemCheckCellDelegate) -> HDZItemCheckCell {
        let cell: HDZItemCheckCell = tableView.dequeueReusableCellWithIdentifier("HDZItemCheckCell", forIndexPath: indexPath) as! HDZItemCheckCell
        cell.delegate = delegate
        return cell
    }
    
}

extension HDZItemCheckCell {
    
    @IBAction func didSelectedDelete(button: UIButton) {
        
        try! HDZOrder.deleteObject(self.order)
        self.delegate?.didSelectedDeleted()
    }
}

