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

	private var itemResult: ItemResult! = nil
	private var request: Alamofire.Request? = nil
	private var indicatorView:CustomIndicatorView!
	private var categoryItems: [Int : [StaticItem]] = [:]
	private var categoryKey: Int = -1
	
    private var attr_flg: AttrFlg = AttrFlg.direct
    private var supplierId: String = ""
    private var categoryName: String = ""
    private var staticItems: [StaticItem] = []
	
	private var displayItemList:[DisplayStaticItem] = []

	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.categoryName
		
        // セル登録
        HDZItemStaticCell.register(self.tableView)
		HDZItemStaticFractionCell.register(self.tableView)
        HDZItemStaticNoimageCell.register(self.tableView)
        HDZItemStaticFractionNoimageCell.register(self.tableView)
		
		// 再読込イベント
		let refreshControl: UIRefreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(reloadRequest), forControlEvents: .ValueChanged)
		self.refreshControl = refreshControl
		
		
		//インジケータ
		self.indicatorView = CustomIndicatorView.createView(self.view.frame.size)
		self.view.addSubview(self.indicatorView)

    }

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		self.request?.resume()

		// API
		self.getItem(self.supplierId)
		
//		self.tableView.reloadData()
	}
	
	override func viewDidDisappear(animated: Bool) {
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
		self.getItem(self.supplierId)
	}

}

// MARK: - Create
extension HDZItemStaticTableViewController {
	
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
		
		self.refreshControl?.beginRefreshing()

		// インジケーター開始
		self.indicatorView.startAnimating()
		
		self.displayItemList.removeAll()

		let completion: (unboxable: ItemResult?) -> Void = { (unboxable) in
			
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
		
		let error: (error: ErrorType?, unboxable: ItemError?) -> Void = { (error, unboxable) in
			
			self.indicatorView.stopAnimating()
			
			self.refreshControl?.endRefreshing()
			
			self.request = nil
		}
		
		// Request
		self.request = HDZApi.item(supplierId, completionBlock: completion, errorBlock: error)
	}

	// 画像取得
	private func requestImage(url: NSURL, completion: (image: UIImage?) -> Void) {
		
		let completionHandler: (Response<NSData, NSError>) -> Void = { (response: Response<NSData, NSError>) in
			if response.result.error != nil {
				
				#if DEBUG
					debugPrint(response.result.error)
					debugPrint(url)
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
		
        // 画像無しチェック
        let category:Category = self.staticItems[indexPath.row].category
        let isNoimage:Int = category.image_flg
        
		if isInt {
			// 整数セル
            if isNoimage == 0 {
                let cell = HDZItemStaticCell.dequeueReusableCell(tableView, forIndexPath: indexPath, staticItem: self.staticItems[indexPath.row], attr_flg: self.attr_flg, supplierId: self.supplierId)
                cell.parent = self
                // 画像
                self.requestImage(self.staticItems[indexPath.row].image) { (image) in
                    cell.iconImageView.image = image
                }
                
                return cell
            }
            // 画像無しセル
            let cell = HDZItemStaticNoimageCell.dequeueReusableCell(tableView, forIndexPath: indexPath, staticItem: self.displayItemList[indexPath.row], attr_flg: self.attr_flg, supplierId: self.supplierId)
            cell.parent = self
            return cell
		}
		else {
			// 分数セル
            if isNoimage == 0 {
                let cell = HDZItemStaticFractionCell.dequeueReusableCell(tableView, forIndexPath: indexPath, staticItem: self.staticItems[indexPath.row], attr_flg: self.attr_flg, supplierId: self.supplierId)
                cell.parent = self
                // 画像
                self.requestImage(self.staticItems[indexPath.row].image) { (image) in
                    cell.iconImageView.image = image
                }
                return cell
            }
            // 画像無しセル
            let cell = HDZItemStaticFractionNoimageCell.dequeueReusableCell(tableView, forIndexPath: indexPath, staticItem: self.displayItemList[indexPath.row], attr_flg: self.attr_flg, supplierId: self.supplierId)
            cell.parent = self
            return cell
		}
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
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
	
	@IBAction func onCheckOrder(sender: AnyObject) {
		
		let controller: HDZItemCheckTableViewController = HDZItemCheckTableViewController.createViewController(self.supplierId)
		self.navigationController?.pushViewController(controller, animated: true)

	}
	
	@IBAction func onBackHome(sender: AnyObject) {
		
		self.navigationController?.popToViewController((self.navigationController?.viewControllers.first)!, animated: true)
	}

}
