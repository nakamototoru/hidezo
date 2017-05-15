//
//  HDZItemStaticFractionNoimageCell.swift
//  buyer
//
//  Created by 庄俊亮 on 2016/11/06.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit

protocol HDZItemStaticFractionNoimageCellDelegate {
    func staticfractionReloadCell()
}

class HDZItemStaticFractionNoimageCell: UITableViewCell {

    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemCount: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var labelUnitPrice: UILabel!
    
    var parent:UITableViewController!
    var delegate:HDZItemFractionViewControllerDelegate?
    
//    private var staticItem: StaticItem!
	var displayItem:DisplayStaticItem! = nil
	var attr_flg: AttrFlg = AttrFlg.direct
	var supplierId: String = ""
	var itemsize:String = "0" {
        didSet {
            self.itemCount.text = itemsize
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Cart
    func updateItem() {
        do {
            try HDZOrder.add(supplierId: self.supplierId, itemId: self.displayItem.id, size: self.itemsize, name: self.displayItem.name, price: self.displayItem.price, scale: self.displayItem.scale, standard: self.displayItem.standard, imageURL: "", dynamic: false, numScale: self.displayItem.num_scale)
        } catch let error as NSError {
            #if DEBUG
                debugPrint(error)
            #endif
        }
    }

    @IBAction func onFractionSelect(_ sender: Any) {
        
        if self.displayItem.num_scale.count > 0 {
            // 分数選択ダイアログ
            let vc:HDZItemFractionViewController = HDZItemFractionViewController.createViewController(parent: self.parent, fractions: self.displayItem.num_scale, itemsize: self.itemsize)
            vc.delegate = self
            //self.parent.presentPopupViewController(vc, animationType: MJPopupViewAnimationFade)
			self.parent.presentPopupViewController(popupViewController: vc)
        }
    }

}

// MARK: - Delegate
extension HDZItemStaticFractionNoimageCell: HDZItemFractionViewControllerDelegate {
    
    func itemfractionSelected(fraction: String) {
        //分数入力
        if fraction != "0" {
            //更新
            self.itemsize = fraction
            self.updateItem()
        }
        else {
            self.itemsize = "0"
            // 注文削除処理
            try! HDZOrder.deleteItem(supplierId: self.supplierId, itemId: self.displayItem.id, dynamic: false)
        }
        
    }
}

// MARK: - Create
extension HDZItemStaticFractionNoimageCell {
    
    internal class func register(tableView: UITableView) {
        let bundle = Bundle.main
        let nib: UINib = UINib(nibName: "HDZItemStaticFractionNoimageCell", bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: "HDZItemStaticFractionNoimageCell")
    }
    
    internal class func dequeueReusableCell(tableView: UITableView, forIndexPath indexPath: IndexPath, staticItem: DisplayStaticItem, attr_flg: AttrFlg, supplierId: String) -> HDZItemStaticFractionNoimageCell {
        
        let cell: HDZItemStaticFractionNoimageCell = tableView.dequeueReusableCell(withIdentifier: "HDZItemStaticFractionNoimageCell", for: indexPath) as! HDZItemStaticFractionNoimageCell
        cell.displayItem = staticItem
        cell.attr_flg = attr_flg
        cell.supplierId = supplierId
        
        cell.indexLabel.text = String(format: "%d", indexPath.row + 1)
        cell.itemName.text = staticItem.name
        
        // アイテム数
        if let item: HDZOrder = try! HDZOrder.queries(supplierId: supplierId, itemId: staticItem.id, dynamic: false) {
            cell.itemsize = item.size
        } else {
            cell.itemsize = "0"
        }
        
        // !!!:デザミシステム
        let standardstr:String = "\(staticItem.standard)"
        let loadingstr:String = "\(staticItem.loading)"
        let scalestr:String = "\(staticItem.scale)"
        if standardstr.isEmpty && loadingstr.isEmpty && scalestr.isEmpty {
            cell.priceLabel.text = ""
        }
        else {
            //cell.priceLabel.text = String(format: "(\(staticItem.standard)・\(String(staticItem.loading))/\(staticItem.scale))")
			
			cell.priceLabel.text = "(" + staticItem.standard + "・" + staticItem.loading + "/" + staticItem.scale + ")"
        }
        
        cell.labelUnitPrice.text = String(format: "単価:\(staticItem.price)円/\(staticItem.scale)")
        
        return cell
    }

}

extension HDZItemStaticFractionNoimageCell {
    
    static func getHeight() -> CGFloat {
        
        let views = Bundle.main.loadNibNamed("HDZItemStaticFractionNoimageCell", owner: self, options: nil)!
		let viewFirst = views.first
        let cell: HDZItemStaticFractionNoimageCell = viewFirst as! HDZItemStaticFractionNoimageCell;
        let height :CGFloat = cell.frame.size.height;
        
        return height;
    }

}
