//
//  HDZItemStaticDetailViewController.swift
//  buyer
//
//  Created by デザミ on 2016/08/25.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZItemStaticDetailViewController: UITableViewController {

	@IBOutlet weak var cellProductCode: UITableViewCell!
	@IBOutlet weak var cellProductName: UITableViewCell!
	@IBOutlet weak var cellPrice: UITableViewCell!
	@IBOutlet weak var cellStandard: UITableViewCell!
	@IBOutlet weak var cellLoading: UITableViewCell!
	@IBOutlet weak var cellScale: UITableViewCell!
	@IBOutlet weak var cellMinCount: UITableViewCell!
	@IBOutlet weak var cellDetail: UITableViewCell!
	
	// 対象商品
	var staticItem: StaticItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

		self.cellProductCode.textLabel?.text = self.staticItem.code
		self.cellProductName.textLabel?.text = self.staticItem.name
		self.cellPrice.textLabel?.text = self.staticItem.price
		self.cellStandard.textLabel?.text = self.staticItem.standard
		self.cellLoading.textLabel?.text = String( self.staticItem.loading )
		self.cellScale.textLabel?.text = self.staticItem.scale
		self.cellMinCount.textLabel?.text = self.staticItem.min_order_count
//		self.cellDetail.textLabel?.text = self.staticItem.detail
		
		// Header
		self.tableView.tableHeaderView = HDZItemStaticDetailHeaderView.createView(staticItem: self.staticItem, parent:self)
		// Footer
		self.tableView.tableFooterView = HDZItemStaticDetailFooterView.createView(staticItem: self.staticItem, parent:self)
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Table view data source
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
	//override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

		if ( indexPath.section == 7 ) {
			return 0.0 // self.tableView.tableFooterView!.frame.size.height
		}

		return super.tableView(tableView, heightForRowAt: indexPath) //super.tableView(tableView, heightForRowAtIndexPath: indexPath)
	}

	
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

}

// MARK: - Create
extension HDZItemStaticDetailViewController {
	
	internal class func createViewController(staticItem: StaticItem) -> HDZItemStaticDetailViewController {
		let controller: HDZItemStaticDetailViewController = UIViewController.createViewController(name: "HDZItemStaticDetailViewController")
		controller.staticItem = staticItem
		return controller
	}
}
