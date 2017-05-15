//
//  HDZItemStaticTableViewController.swift
//  buyer
//
//  Created by Shun Nakahara on 7/31/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire
import Unbox

class HDZItemStaticTableViewController: UITableViewController {

	var itemResult: ItemResult! = nil
	var request: Alamofire.Request? = nil
	var indicatorView:CustomIndicatorView!
	var categoryItems: [Int : [StaticItem]] = [:]
	var categoryKey: Int = -1
	
	var attr_flg: AttrFlg = AttrFlg.direct
	var supplierId: String = ""
	var categoryName: String = ""
	var staticItems: [StaticItem] = []
	
	var displayItemList:[DisplayStaticItem] = []

	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.categoryName
		
        // セル登録
        HDZItemStaticCell.register(tableView: self.tableView)
		HDZItemStaticFractionCell.register(tableView: self.tableView)
        HDZItemStaticNoimageCell.register(tableView: self.tableView)
        HDZItemStaticFractionNoimageCell.register(tableView: self.tableView)
		
		// 再読込イベント
		let refreshControl: UIRefreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(reloadRequest), for: .valueChanged)
		self.refreshControl = refreshControl
		
		
		//インジケータ
		self.indicatorView = CustomIndicatorView.createView(framesize: self.view.frame.size)
		self.view.addSubview(self.indicatorView)

    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		self.request?.resume()

		// API
		self.getItem(supplierId: self.supplierId)
		
//		self.tableView.reloadData()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		self.request?.suspend()
	}

	deinit {
		self.request?.cancel()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	func reloadRequest() {
		self.getItem(supplierId: self.supplierId)
	}

}

// MARK: - Create
extension HDZItemStaticTableViewController {
	
	internal class func createViewController(supplierId:String, attr_flg:AttrFlg, categoryKey:Int, categoryName:String) -> HDZItemStaticTableViewController {
		let controller: HDZItemStaticTableViewController = UIViewController.createViewController(name: "HDZItemStaticTableViewController")

		controller.supplierId = supplierId
		controller.attr_flg = attr_flg
		controller.categoryName = categoryName
		controller.categoryKey = categoryKey
		
		return controller
	}
}

// MARK: - API
extension HDZItemStaticTableViewController {
	
	func getItem(supplierId: String) {
		
		self.refreshControl?.beginRefreshing()

		// インジケーター開始
		self.indicatorView.startAnimating()
		
		self.displayItemList.removeAll()

		let completion: (_ unboxable: ItemResult?) -> Void = { (unboxable) in
			
			self.request = nil
			guard let result: ItemResult = unboxable else {
				return
			}
			self.itemResult = result
			
			// 静的商品の登録
			self.categoryItems = [:]
			if let staticItems: [StaticItem] = result.staticItems {
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
			
			// 表示用
			for staticItem in self.staticItems {
				var item:DisplayStaticItem = DisplayStaticItem()
				item.code = staticItem.code
				item.detail = staticItem.detail
				item.id = staticItem.id
				item.loading = staticItem.loading
				item.min_order_count = staticItem.min_order_count
				item.name = staticItem.name
				item.num_scale = staticItem.num_scale
				item.price = staticItem.price
				item.scale = staticItem.scale
				item.standard = staticItem.standard
				self.displayItemList.append(item)
			}
			
			self.indicatorView.stopAnimating()
			
			self.refreshControl?.endRefreshing()
			
			self.tableView.reloadData()
		}
		
		let error: (_ error: Error?, _ unboxable: ItemError?) -> Void = { (error, unboxable) in
			
			self.indicatorView.stopAnimating()
			
			self.refreshControl?.endRefreshing()
			
			self.request = nil
		}
		
		// Request
		self.request = HDZApi.item(supplierId: supplierId, completionBlock: completion, errorBlock: error)
	}

	// 画像取得
	func requestImage(url: URL, completion: @escaping (_ image: UIImage?) -> Void) {
		
//		let completionHandler: (Response<NSData, NSError>) -> Void = { (response: Response<NSData, NSError>) in
//			if response.result.error != nil {
//				
//				#if DEBUG
//					debugPrint(response.result.error)
//					debugPrint(url)
//				#endif
//				
//				let sakanaimage:UIImage = UIImage(named: "sakana")!
//				completion(image: sakanaimage)
//			}
//			else {
//				if let data: NSData = response.result.value {
//					if let resultImage: UIImage = UIImage(data: data) {
//						// 画像返す
//						completion(image: resultImage)
//					}
//				}
//				else {
//					let sakanaimage:UIImage = UIImage(named: "sakana")!
//					completion(image: sakanaimage)
//				}
//			}
//		}
		
		//let _: Alamofire.Request? = Alamofire.request(.GET, url).responseData(completionHandler: completionHandler)
		let _ = AlamofireManager.requestData(url: url, success: { value in
			if let resultImage: UIImage = UIImage(data: value) {
				// 画像返す
				completion(resultImage)
			}
			else {
				let sakanaimage:UIImage = UIImage(named: "sakana")!
				completion(sakanaimage)
			}

		}) { error in
			let sakanaimage:UIImage = UIImage(named: "sakana")!
			completion(sakanaimage)
		}
	}
}

// MARK: - Table view data source
extension HDZItemStaticTableViewController {
	
	override func numberOfSections(in tableView: UITableView) -> Int {
	//func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
	//func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.staticItems.count
    }
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	//func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
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
		
        // 画像無しチェック
        let category:Category = self.staticItems[indexPath.row].category
        let isNoimage:Int = category.image_flg
        
		if isInt {
			// 整数セル
            if isNoimage == 0 {
                let cell = HDZItemStaticCell.dequeueReusableCell(tableView: tableView, forIndexPath: indexPath, staticItem: self.staticItems[indexPath.row], attr_flg: self.attr_flg, supplierId: self.supplierId)
                cell.parent = self
                // 画像
                self.requestImage(url: self.staticItems[indexPath.row].image) { (image) in
                    cell.iconImageView.image = image
                }
                
                return cell
            }
            // 画像無しセル
            let cell = HDZItemStaticNoimageCell.dequeueReusableCell(tableView: tableView, forIndexPath: indexPath, staticItem: self.displayItemList[indexPath.row], attr_flg: self.attr_flg, supplierId: self.supplierId)
            cell.parent = self
            return cell
		}
		else {
			// 分数セル
            if isNoimage == 0 {
                let cell = HDZItemStaticFractionCell.dequeueReusableCell(tableView: tableView, forIndexPath: indexPath, staticItem: self.staticItems[indexPath.row], attr_flg: self.attr_flg, supplierId: self.supplierId)
                cell.parent = self
                // 画像
                self.requestImage(url: self.staticItems[indexPath.row].image) { (image) in
                    cell.iconImageView.image = image
                }
                return cell
            }
            // 画像無しセル
            let cell = HDZItemStaticFractionNoimageCell.dequeueReusableCell(tableView: tableView, forIndexPath: indexPath, staticItem: self.displayItemList[indexPath.row], attr_flg: self.attr_flg, supplierId: self.supplierId)
            cell.parent = self
            return cell
		}
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
	//func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
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
        
        // 画像無しチェック
        let category:Category = self.staticItems[indexPath.row].category
        let isNoimage:Int = category.image_flg

        if isInt {
            // 整数セル
            if isNoimage == 0 {
                return HDZItemStaticCell.getHeight()
            }
            
            return HDZItemStaticNoimageCell.getHeight()
        }
        else {
            // 分数セル
            if isNoimage == 0 {
                return HDZItemStaticFractionCell.getHeight()
            }
        }
		return HDZItemStaticFractionNoimageCell.getHeight()
	}

	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
	//func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		
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

        // 画像無しチェック
        let category:Category = self.staticItems[indexPath.row].category
        let isNoimage:Int = category.image_flg
        
        if isNoimage == 0 {
            // 画像の初期化
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
}

// MARK: - Action
extension HDZItemStaticTableViewController {
	
	@IBAction func onCheckOrder(_ sender: Any) {
		
		let controller: HDZItemCheckTableViewController = HDZItemCheckTableViewController.createViewController(supplierId: self.supplierId)
		self.navigationController?.pushViewController(controller, animated: true)

	}
	
	@IBAction func onBackHome(_ sender: Any) {
		
		self.navigationController?.popToViewController((self.navigationController?.viewControllers.first)!, animated: true)
	}

}
