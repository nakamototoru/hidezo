//
//  HDZItemStaticTableViewController.swift
//  buyer
//
//  Created by Shun Nakahara on 7/31/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire

class HDZItemStaticTableViewController: UITableViewController {

	private var itemResult: ItemResult! = nil
	private var request: Alamofire.Request? = nil
	private var indicatorView:CustomIndicatorView!
	private var categoryItems: [Int : [StaticItem]] = [:]
	private var categoryKey: Int = -1
	
    private var attr_flg: AttrFlg = AttrFlg.direct
    private var supplierId: String = ""
    private var categoryName: String = ""
    private var staticItems: [StaticItem] = []
	

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.categoryName
		
        HDZItemStaticCell.register(self.tableView)
		HDZItemStaticFractionCell.register(self.tableView)
		
		//インジケータ
		self.indicatorView = CustomIndicatorView.createView(self.view.frame.size)
		self.view.addSubview(self.indicatorView)

    }

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		// API
		self.getItem(self.supplierId)
		
//		self.tableView.reloadData()
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - Create
extension HDZItemStaticTableViewController {
    
//    internal class func createViewController(categoryName: String, categoryItems: [StaticItem], attr_flg: AttrFlg, supplierId: String) -> HDZItemStaticTableViewController {
//        let controller: HDZItemStaticTableViewController = UIViewController.createViewController("HDZItemStaticTableViewController")
//        controller.categoryName = categoryName
//        controller.staticItems = categoryItems
//        controller.attr_flg = attr_flg
//        controller.supplierId = supplierId
//        return controller
//    }
	
	internal class func createViewController(supplierId:String, attr_flg:AttrFlg, categoryKey:Int, categoryName:String) -> HDZItemStaticTableViewController {
		let controller: HDZItemStaticTableViewController = UIViewController.createViewController("HDZItemStaticTableViewController")

		controller.supplierId = supplierId
		controller.attr_flg = attr_flg
		controller.categoryName = categoryName
		controller.categoryKey = categoryKey
		
		return controller
	}
}

// MARK: - API
extension HDZItemStaticTableViewController {
	
	private func getItem(supplierId: String) {
		
		// インジケーター開始
		self.indicatorView.startAnimating()
		
		let completion: (unboxable: ItemResult?) -> Void = { (unboxable) in
			
			self.request = nil
			guard let result: ItemResult = unboxable else {
				return
			}
			self.itemResult = result
			
			// 静的商品の登録
			self.categoryItems = [:]
			if let staticItems: [StaticItem] = result.staticItem {
				for staticItem in staticItems {
					let index:Int = Int(staticItem.category.id)!
					
					if self.categoryItems[ index ] == nil {
						self.categoryItems[ index ] = [staticItem]
					} else {
						self.categoryItems[ index ]?.append(staticItem)
					}
				}
			}
			self.staticItems = self.categoryItems[ self.categoryKey ]!
			// End
			
			self.indicatorView.stopAnimating()
			
			self.tableView.reloadData()
		}
		
		let error: (error: ErrorType?, unboxable: ItemError?) -> Void = { (error, unboxable) in
			
			self.indicatorView.stopAnimating()
			
			self.request = nil
		}
		
		// Request
		self.request = HDZApi.item(supplierId, completionBlock: completion, errorBlock: error)
	}

	// 画像取得
	private func requestImage(url: NSURL, completion: (image: UIImage?) -> Void) {
		
		#if DEBUG
			debugPrint(url)
		#endif
		
		let completionHandler: (Response<NSData, NSError>) -> Void = { (response: Response<NSData, NSError>) in
			if response.result.error != nil {
				
				#if DEBUG
					debugPrint(response.result.error)
				#endif
				
				let sakanaimage:UIImage = UIImage(named: "sakana")!
				completion(image: sakanaimage)
			}
			else {
				if let data: NSData = response.result.value {
					if let resultImage: UIImage = UIImage(data: data) {
						// 画像返す
						completion(image: resultImage)
					}
				}
				else {
					
//					#if DEBUG
//						debugPrint("取得失敗" + String(url))
//					#endif
					
					let sakanaimage:UIImage = UIImage(named: "sakana")!
					completion(image: sakanaimage)
				}
			}
		}
		let _: Alamofire.Request? = Alamofire.request(.GET, url).responseData(completionHandler: completionHandler)
	}

}

// MARK: - Table view data source
extension HDZItemStaticTableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
	
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.staticItems.count
    }
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		// 整数かどうかチェック
		var isInt: Bool = true
		for numScale: String in self.staticItems[indexPath.row].num_scale {
			if let _: Int = Int(numScale) {
				//整数
			} else {
				//分数
				isInt = false
			}
		}
		
		if isInt {
			// 整数セル
			let cell = HDZItemStaticCell.dequeueReusableCell(tableView, forIndexPath: indexPath, staticItem: self.staticItems[indexPath.row], attr_flg: self.attr_flg, supplierId: self.supplierId)
			cell.parent = self
			
//			#if DEBUG
//				debugPrint("ROW:" + String(indexPath.row) )
//			#endif

			// 画像
			self.requestImage(self.staticItems[indexPath.row].image) { (image) in
				cell.iconImageView.image = image
			}
			
			return cell
		}
		else {
			// 分数セル
			let cell = HDZItemStaticFractionCell.dequeueReusableCell(tableView, forIndexPath: indexPath, staticItem: self.staticItems[indexPath.row], attr_flg: self.attr_flg, supplierId: self.supplierId)
			cell.parent = self
			
//			#if DEBUG
//				debugPrint("ROW:" + String(indexPath.row) )
//			#endif

			// 画像
			self.requestImage(self.staticItems[indexPath.row].image) { (image) in
				cell.iconImageView.image = image
			}

			return cell
		}
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		return HDZItemStaticCell.getHeight()
	}

	override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		
		// 整数かどうかチェック
		var isInt: Bool = true
		for numScale: String in self.staticItems[indexPath.row].num_scale {
			if let _: Int = Int(numScale) {
				//整数
			} else {
				//分数
				isInt = false
			}
		}

		let sakanaimage:UIImage = UIImage(named: "sakana")!

		if isInt {
			let customcell:HDZItemStaticCell = cell as! HDZItemStaticCell
			customcell.iconImageView.image = sakanaimage
		}
		else {
			let customcell:HDZItemStaticFractionCell = cell as! HDZItemStaticFractionCell
			customcell.iconImageView.image = sakanaimage
		}
		
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