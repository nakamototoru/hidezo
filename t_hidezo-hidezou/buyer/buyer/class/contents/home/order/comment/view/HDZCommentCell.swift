//
//  HDZCommentCell.swift
//  seller
//
//  Created by NakaharaShun on 6/25/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZCommentCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private var messageInfo: MessageInfo! = nil
    private var maxIndex: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension HDZCommentCell {
    
    internal class func register(tableView: UITableView) {
        let bundle: NSBundle = NSBundle.mainBundle()
        let nib: UINib = UINib(nibName: "HDZCommentCell", bundle: bundle)
        tableView.registerNib(nib, forCellReuseIdentifier: "HDZCommentCell")
    }
    
    internal class func dequeueReusable(tableView: UITableView, indexPath: NSIndexPath, messageInfo: MessageInfo, maxIndex: Int) -> HDZCommentCell {
        let cell: HDZCommentCell = tableView.dequeueReusableCellWithIdentifier("HDZCommentCell", forIndexPath: indexPath) as! HDZCommentCell
        cell.messageInfo = messageInfo
        cell.nameLabel.text = String(format: "%@ : %@", messageInfo.name, messageInfo.charge)
        cell.commentLabel.text = messageInfo.message
        cell.dateLabel.text = messageInfo.posted_at
        cell.indexLabel.text = String(format: "%d", maxIndex - indexPath.row)
        return cell
    }
	
	static func getHeight() -> CGFloat {
		
		let views: NSArray = NSBundle.mainBundle().loadNibNamed("HDZCommentCell", owner: self, options: nil)
		let cell: HDZCommentCell = views.firstObject as! HDZCommentCell;
		let height :CGFloat = cell.frame.size.height;
		
		return height;
	}

}
