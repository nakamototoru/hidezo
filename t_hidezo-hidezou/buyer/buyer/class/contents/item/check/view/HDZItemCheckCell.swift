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
		
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

// MARK: - Create
extension HDZItemCheckCell {
    
    internal class func register(tableView: UITableView) {
        let bundle = Bundle.main
        let nib: UINib = UINib(nibName: "HDZItemCheckCell", bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: "HDZItemCheckCell")
    }

    internal class func dequeueReusableCell(tableView: UITableView, indexPath: IndexPath, delegate: HDZItemCheckCellDelegate) -> HDZItemCheckCell {
        let cell: HDZItemCheckCell = tableView.dequeueReusableCell(withIdentifier: "HDZItemCheckCell", for: indexPath) as! HDZItemCheckCell
        cell.delegate = delegate
        return cell
    }
    
}

// MARK: - Cell
extension HDZItemCheckCell {
	
	static func getHeight() -> CGFloat {
		
		let views = Bundle.main.loadNibNamed("HDZItemCheckCell", owner: self, options: nil)!
		let viewFirst = views.first
		let cell: HDZItemCheckCell = viewFirst as! HDZItemCheckCell;
		let height :CGFloat = cell.frame.size.height;
		
		return height;
	}

}

// MARK: - API
extension HDZItemCheckCell {
	
	// カート内容を更新
	func updateCart(newsizestr: String ) {
		
		let supplierId:String = self.order.supplierId
		try! HDZOrder.updateSize(supplierId: supplierId, itemId: self.order.itemId, dynamic: self.order.dynamic, newsize: newsizestr)

		// 親に通達
		self.delegate?.itemcheckcellReload()
	}
	
	// カートから削除
	func deleteCartObject() {
		
		try! HDZOrder.deleteObject(object: self.order)
		self.delegate?.itemcheckcellReload()
	}

}

// MARK: - Action
extension HDZItemCheckCell {
    
    @IBAction func didSelectedDelete(_ sender: Any) {
		
		self.deleteCartObject()
    }
	
	@IBAction func onSelectedAdd(_ sender: Any) {
		
		// カート内カウント加算
		var value:Int = Int(self.order.size)!
		value += 1
		if (value > 100) {
			value = 100
		}
		let newsize:String = String(value)

		updateCart(newsizestr: newsize)
	}
	
	@IBAction func onSelectedSub(_ sender: Any) {
		
		// カート内カウント減算
		var value:Int = Int(self.order.size)!
		value -= 1
		if (value > 0) {
			//更新
			let newsize:String = String(value)
			updateCart(newsizestr: newsize)
		}
		else {
			value = 0
			//削除
			self.deleteCartObject()
		}
	}
	
}
