//
//  HDZItemStaticNoimageCell.swift
//  buyer
//
//  Created by 庄俊亮 on 2016/11/06.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZItemStaticNoimageCell: UITableViewCell {

    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemCount: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var labelUnitPrice: UILabel!
    
    var parent:UITableViewController!
    
    private var staticItem: StaticItem!
    private var attr_flg: AttrFlg = AttrFlg.direct
    private var supplierId: String = ""
    var itemsize:String = "0" {
        didSet {
            self.itemCount.text = itemsize
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Cart
    func updateItem() {
    
        do {
            try HDZOrder.add(self.supplierId, itemId: self.staticItem.id, size: self.itemsize, name: self.staticItem.name, price: self.staticItem.price, scale: self.staticItem.scale, standard: self.staticItem.standard, imageURL: self.staticItem.image.absoluteString, dynamic: false, numScale: self.staticItem.num_scale)
        } catch let error as NSError {
            #if DEBUG
                debugPrint(error)
            #endif
        }
    }

    // Action
    @IBAction func didSelectedAdd(button: UIButton) {
        
        var value:Int = Int(self.itemsize)!
        value += 1
        if (value > 100) {
            value = 100
        }
        self.itemsize = String(value)
        
        self.updateItem()
    }
    
    @IBAction func didSelectedSub(button: UIButton) {
        
        var value:Int = Int(self.itemsize)!
        value -= 1
        if (value > 0) {
            //更新
            self.itemsize = String(value)
            self.updateItem()
        }
        else {
            value = 0
            self.itemsize = String(value)
            //削除
            try! HDZOrder.deleteItem(self.supplierId, itemId: self.staticItem.id, dynamic: false)
        }
    }

}

// MARK: - Create
extension HDZItemStaticNoimageCell {
    
    internal class func register(tableView: UITableView) {
        let bundle: NSBundle = NSBundle.mainBundle()
        let nib: UINib = UINib(nibName: "HDZItemStaticNoimageCell", bundle: bundle)
        tableView.registerNib(nib, forCellReuseIdentifier: "HDZItemStaticNoimageCell")
    }
    
    internal class func dequeueReusableCell(tableView: UITableView, forIndexPath indexPath: NSIndexPath, staticItem: StaticItem, attr_flg: AttrFlg, supplierId: String) -> HDZItemStaticNoimageCell {
        
        let cell: HDZItemStaticNoimageCell = tableView.dequeueReusableCellWithIdentifier("HDZItemStaticNoimageCell", forIndexPath: indexPath) as! HDZItemStaticNoimageCell
        cell.staticItem = staticItem
        cell.attr_flg = attr_flg
        cell.supplierId = supplierId
        
        cell.indexLabel.text = String(format: "%d", indexPath.row + 1)
        cell.itemName.text = staticItem.name
        
        // アイテム数
        cell.itemsize = "0"
        if let item: HDZOrder = try! HDZOrder.queries(supplierId, itemId: staticItem.id, dynamic: false) {
            if let _: Int = Int(item.size) {
                cell.itemsize = item.size
            }
        }
        
        // 情報
        let standardstr:String = "\(staticItem.standard)"
        let loadingstr:String = "\(staticItem.loading)"
        let scalestr:String = "\(staticItem.scale)"
        if standardstr.isEmpty && loadingstr.isEmpty && scalestr.isEmpty {
            cell.priceLabel.text = ""
        }
        else {
            cell.priceLabel.text = String(format: "(\(staticItem.standard)・\(String(staticItem.loading))/\(staticItem.scale))")
        }
        cell.labelUnitPrice.text = String(format: "単価:\(staticItem.price)円/\(staticItem.scale)")
        
        return cell
    }
}

// MARK: - Cell
extension HDZItemStaticNoimageCell {
    
    static func getHeight() -> CGFloat {
        
        let views: NSArray = NSBundle.mainBundle().loadNibNamed("HDZItemStaticNoimageCell", owner: self, options: nil)!
        let cell: HDZItemStaticNoimageCell = views.firstObject as! HDZItemStaticNoimageCell;
        let height :CGFloat = cell.frame.size.height;
        
        return height;
    }

}
