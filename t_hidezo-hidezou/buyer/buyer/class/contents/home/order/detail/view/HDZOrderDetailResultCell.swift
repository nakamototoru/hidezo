//
//  HDZOrderDetailResultCell.swift
//  buyer
//
//  Created by 庄俊亮 on 2016/11/01.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZOrderDetailResultCell: UITableViewCell {

    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var postageLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var chargeLabel: UILabel!
    @IBOutlet weak var deliveredDayLabel: UILabel!
    @IBOutlet weak var deliveredPlaceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    internal class func register(tableView: UITableView) {
        let bundle = Bundle.main
        let nib: UINib = UINib(nibName: "HDZOrderDetailResultCell", bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: "HDZOrderDetailResultCell")
    }
    
    internal class func dequeueReusableCell(controller: HDZOrderDetailTableViewController, tableView: UITableView, for indexPath: IndexPath) -> HDZOrderDetailResultCell {
        
        let cell: HDZOrderDetailResultCell = tableView.dequeueReusableCell(withIdentifier: "HDZOrderDetailResultCell", for: indexPath) as! HDZOrderDetailResultCell
		
        return cell
    }

    static func getHeight() -> CGFloat {
        
        let views = Bundle.main.loadNibNamed("HDZOrderDetailResultCell", owner: self, options: nil)!
		let viewFirst = views.first
        let cell: HDZOrderDetailResultCell = viewFirst as! HDZOrderDetailResultCell
        let height :CGFloat = cell.frame.size.height
        
        return height
    }

}
