//
//  HDZItemStaticTableViewController.swift
//  buyer
//
//  Created by Shun Nakahara on 7/31/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZItemStaticTableViewController: UITableViewController {

    var attr_flg: AttrFlg = AttrFlg.direct
    var supplierId: Int = 0
    var categoryName: String = ""
    var staticItem: [StaticItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.categoryName
        HDZItemStaticCell.register(self.tableView)

		HDZItemStaticFractionCell.register(self.tableView)
    }

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		self.tableView.reloadData()
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension HDZItemStaticTableViewController {
    
    internal class func createViewController(categoryName: String, categoryItems: [StaticItem], attr_flg: AttrFlg, supplierId: Int) -> HDZItemStaticTableViewController {
        let controller: HDZItemStaticTableViewController = UIViewController.createViewController("HDZItemStaticTableViewController")
        controller.categoryName = categoryName
        controller.staticItem = categoryItems
        controller.attr_flg = attr_flg
        controller.supplierId = supplierId
        return controller
    }
}


// MARK: - Table view data source
extension HDZItemStaticTableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.staticItem.count
    }
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		// 整数かどうかチェック
		var isInt: Bool = true
		for numScale: String in self.staticItem[indexPath.row].num_scale {
			if let _: Int = Int(numScale) {
				//整数
			} else {
				//分数
				isInt = false
			}
		}
		
		if isInt {
			// 整数セル
			let cell = HDZItemStaticCell.dequeueReusableCell(tableView, forIndexPath: indexPath, staticItem: self.staticItem[indexPath.row], attr_flg: self.attr_flg, supplierId: self.supplierId)
			cell.parent = self
			
			return cell
		}
		else {
			// 分数セル
			let cell = HDZItemStaticFractionCell.dequeueReusableCell(tableView, forIndexPath: indexPath, staticItem: self.staticItem[indexPath.row], attr_flg: self.attr_flg, supplierId: self.supplierId)
			cell.parent = self
			
			return cell
		}
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		return HDZItemStaticCell.getHeight()
	}

}

// MARK: - Action
extension HDZItemStaticTableViewController {
	
	@IBAction func onCheckOrder(sender: AnyObject) {
		
		let controller: HDZItemCheckTableViewController = HDZItemCheckTableViewController.createViewController(self.supplierId)
		self.navigationController?.pushViewController(controller, animated: true)

	}
	
	@IBAction func onBackHome(sender: AnyObject) {
		
		self.navigationController?.popToViewController((self.navigationController?.viewControllers.first)!, animated: true)
	}

}