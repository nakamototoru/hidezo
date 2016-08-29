//
//  HDZItemCheckCell.swift
//  buyer
//
//  Created by Shun Nakahara on 8/1/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit

protocol HDZItemCheckCellDelegate: NSObjectProtocol {
//    func didSelectedDeleted()
	func itemcheckcellReload()
}

class HDZItemCheckCell: UITableViewCell {

    @IBOutlet weak var indexText: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var priceLabel: UILabel!
	
//    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var sizeLabel: UILabel!
	
	var parent:UIViewController!
	
    var order: HDZOrder! = nil
    weak var delegate: HDZItemCheckCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
//		//画像タップ
//		let myTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HDZItemCheckCell.tapGestureFromImageView1(_:)))
//		self.iconImageView.addGestureRecognizer(myTap)

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

// MARK: - Create
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

// MARK: - Cell
extension HDZItemCheckCell {
	
	static func getHeight() -> CGFloat {
		
		let views: NSArray = NSBundle.mainBundle().loadNibNamed("HDZItemCheckCell", owner: self, options: nil)
		let cell: HDZItemCheckCell = views.firstObject as! HDZItemCheckCell;
		let height :CGFloat = cell.frame.size.height;
		
		return height;
	}

}

// MARK: - API
extension HDZItemCheckCell {
	
	private func updateCart(newsizestr: String ) {
		
		let supplierId:String = self.order.supplierId
		try! HDZOrder.updateSize(supplierId, itemId: self.order.itemId, dynamic: self.order.dynamic, newsize: newsizestr)

		//
		self.delegate?.itemcheckcellReload()
		
	}
	
	private func deleteCartObject() {
		
		try! HDZOrder.deleteObject(self.order)
		self.delegate?.itemcheckcellReload()
	}

}

// MARK: - Action
extension HDZItemCheckCell {
    
    @IBAction func didSelectedDelete(button: UIButton) {
		
		self.deleteCartObject()
		
    }
	
	@IBAction func onSelectedAdd(sender: AnyObject) {
		
		// TODO:カート内カウント加算
//		NSLog("TODO:カート内カウント加算")
		
		var value:Int = Int(self.order.size)!
		value += 1
		if (value > 100) {
			value = 100
		}
		let newsize:String = String(value)

		updateCart(newsize)
	}
	
	@IBAction func onSelectedSub(sender: AnyObject) {
		
		// TODO:カート内カウント減算
//		NSLog("TODO:カート内カウント減算")
		var value:Int = Int(self.order.size)!
		value -= 1
		if (value > 0) {
			//更新
			let newsize:String = String(value)
			updateCart(newsize)
		}
		else {
			value = 0
			//削除
			self.deleteCartObject()
		}
	}
	
}
