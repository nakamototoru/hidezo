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
    
	var messageInfo: MessageInfo! = nil
	var maxIndex: Int = 0
	
	var parent:UIViewController!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		let tg:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapCommentLabel))
		self.commentLabel.addGestureRecognizer(tg)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

// MARK: - Create
extension HDZCommentCell {
    
    internal class func register(tableView: UITableView) {
        let bundle: Bundle = Bundle.main
        let nib: UINib = UINib(nibName: "HDZCommentCell", bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: "HDZCommentCell")
    }
    
    internal class func dequeueReusable(tableView: UITableView, indexPath: IndexPath, messageInfo: MessageInfo, maxIndex: Int) -> HDZCommentCell {
        let cell: HDZCommentCell = tableView.dequeueReusableCell(withIdentifier: "HDZCommentCell", for: indexPath) as! HDZCommentCell
        cell.messageInfo = messageInfo
        cell.nameLabel.text = String(format: "%@ : %@", messageInfo.name, messageInfo.charge)
        cell.commentLabel.text = messageInfo.message
        cell.dateLabel.text = messageInfo.posted_at
        cell.indexLabel.text = String(format: "%d", maxIndex - indexPath.row)
        return cell
    }
	
	static func getHeight() -> CGFloat {
		
		//Bundle.main.loadNibNamed(name: String, owner: Any?, options: [AnyHashable : Any]?)
		
		let views = Bundle.main.loadNibNamed("HDZCommentCell", owner: self, options: nil)!
		let viewFirst = views.first
		let cell: HDZCommentCell = viewFirst as! HDZCommentCell
		let height :CGFloat = cell.frame.size.height
		
		return height;
	}

}

// MARK: - Gesture
extension HDZCommentCell {
	
	func onTapCommentLabel(g:UIGestureRecognizer) {
		
		print("onTapCommentLabel")
		
		let vc:HDZCommentDetailViewController = HDZCommentDetailViewController(nibName: "HDZCommentDetailViewController", bundle: nil)
		vc.textDetail = messageInfo.message
		//self.parent .presentPopupViewController(vc, animationType: MJPopupViewAnimationFade)
		self.parent.presentPopupViewController(popupViewController: vc)
	}
}
