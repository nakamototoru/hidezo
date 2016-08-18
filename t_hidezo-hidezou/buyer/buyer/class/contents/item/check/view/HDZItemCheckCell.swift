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
	
	var parent:UIViewController!
	
    var order: HDZOrder! = nil
    weak var delegate: HDZItemCheckCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		//画像タップ
		let myTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZItemDinamicHeaderView.tapGestureFromImageView1(_:)))
		self.iconImageView.addGestureRecognizer(myTap)

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

extension HDZItemCheckCell {
	
	func openImageViewer(imageview:UIImageView) {
		
		let imageProvider = SomeImageProvider()
		let buttonAssets = CloseButtonAssets(normal: UIImage(named:"close_normal")!, highlighted: UIImage(named: "close_highlighted"))
		
		let imagesize = imageview.frame.size
		let configuration = ImageViewerConfiguration(imageSize: CGSize(width: imagesize.width, height: imagesize.height), closeButtonAssets: buttonAssets)
		
		let imageViewer = ImageViewerController(imageProvider: imageProvider, configuration: configuration, displacedView: imageview)
		self.parent.presentImageViewer(imageViewer)
	}
	
	func tapGestureFromImageView1(sender:UITapGestureRecognizer){
		openImageViewer(self.iconImageView)
	}

}
