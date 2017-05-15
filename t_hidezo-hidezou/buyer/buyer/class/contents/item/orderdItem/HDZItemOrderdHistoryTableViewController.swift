//
//  HDZItemOrderdHistoryTableViewController.swift
//  buyer
//
//  Created by 庄俊亮 on 2016/11/08.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire
import Unbox

class HDZItemOrderdHistoryTableViewController: UITableViewController {

	var request: Alamofire.Request? = nil
	var resultOrderdItem: OrderdItemResult? = nil

	var supplierId: String = ""
	var attr_flg: AttrFlg = AttrFlg.direct
	//    private var staticItems: [StaticItem] = []
	var displayItemList:[DisplayStaticItem] = []

	var indicatorView:CustomIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.title = "履歴から注文"
        
        // セル登録
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

    func reloadRequest() {
        getOrderdItem(supplierId: supplierId)
    }
    
    func getOrderdItem(supplierId: String) {
        
        self.refreshControl?.beginRefreshing()
        
        // インジケーター開始
        self.indicatorView.startAnimating()
		
		self.displayItemList.removeAll()
		
        let completion: (_ unboxable: OrderdItemResult?) -> Void = { (unboxable) in
            
            self.request = nil
            
            guard let result:OrderdItemResult = unboxable else {
                return
            }
            self.resultOrderdItem = result
            
            // JSON解析
            if let items: [OrderdStaticItem] = result.orderdStaticItems {
				// 表示用
				for staticItem in items {
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
            }
			
            //            
            self.indicatorView.stopAnimating()
            self.refreshControl?.endRefreshing()
			
			if self.displayItemList.count == 0 {
				self.openAlertNoHistory()
			}
			else {
				// 再描画
				self.tableView.reloadData()
			}
        }
		
        let error: (_ error: Error?, _ unboxable: ItemError?) -> Void = { (error, unboxable) in
            
            self.indicatorView.stopAnimating()
            self.refreshControl?.endRefreshing()
            self.request = nil
			
			self.openAlertNoHistory()
        }
        
        // Request
        self.request = HDZApi.orderd_item(supplierId: supplierId, completionBlock: completion, errorBlock: error)
    }

	func openAlertNoHistory() {
		// アラートビュー
		let action2:UIAlertAction = UIAlertAction(title: "戻る", style: .default, handler: { (action:UIAlertAction!) in
			// 画面戻る
			self.navigationController?.popViewController(animated: false)
		})
		let controller: UIAlertController = UIAlertController(title: "注文履歴がありません。", message: "", preferredStyle: .alert)
		controller.addAction(action2)
		self.present(controller, animated: false, completion: nil)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.request?.resume()

        getOrderdItem(supplierId: supplierId)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.request?.suspend()
    }
    
    deinit {
        self.request?.cancel()
    }

    // MARK: - Table view data source

//	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return self.displayItemList.count
//    }

//	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        // 整数かどうかチェック
//        var isInt: Bool = true
//        for numScale: String in self.displayItemList[indexPath.row].num_scale {
//            if let _: Int = Int(numScale) {
//                //整数
//            } else {
//                //分数
//                isInt = false
//            }
//        }
//
//        if isInt {
//            // 整数セル
//            // 画像無しセル
//            let cell = HDZItemStaticNoimageCell.dequeueReusableCell(tableView: tableView, forIndexPath: indexPath, staticItem: self.displayItemList[indexPath.row], attr_flg: self.attr_flg, supplierId: self.supplierId)
//            cell.parent = self
//            return cell
//        }
//        else {
//            // 分数セル
//            // 画像無しセル
//            let cell = HDZItemStaticFractionNoimageCell.dequeueReusableCell(tableView: tableView, forIndexPath: indexPath, staticItem: self.displayItemList[indexPath.row], attr_flg: self.attr_flg, supplierId: self.supplierId)
//            cell.parent = self
//            return cell
//        }
//    }

//	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//		
//		// 整数かどうかチェック
//		var isInt: Bool = true
//		for numScale: String in self.displayItemList[indexPath.row].num_scale {
//			if let _: Int = Int(numScale) {
//				//整数
//			} else {
//				//分数
//				isInt = false
//			}
//		}
//		
//		if isInt {
//			// 整数セル
//			return HDZItemStaticNoimageCell.getHeight()
//		}
//		return HDZItemStaticFractionNoimageCell.getHeight()
//	}
	
	@IBAction func onCheckOrder(_ sender: Any) {
		
		let controller: HDZItemCheckTableViewController = HDZItemCheckTableViewController.createViewController(supplierId: self.supplierId)
		self.navigationController?.pushViewController(controller, animated: true)
		
	}
	
	@IBAction func onBackHome(_ sender: Any) {
		
		self.navigationController?.popToViewController((self.navigationController?.viewControllers.first)!, animated: true)
	}

}

extension HDZItemOrderdHistoryTableViewController {
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.displayItemList.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		// 整数かどうかチェック
		var isInt: Bool = true
		for numScale: String in self.displayItemList[indexPath.row].num_scale {
			if let _: Int = Int(numScale) {
				//整数
			} else {
				//分数
				isInt = false
			}
		}
		
		if isInt {
			// 整数セル
			// 画像無しセル
			let cell = HDZItemStaticNoimageCell.dequeueReusableCell(tableView: tableView, forIndexPath: indexPath, staticItem: self.displayItemList[indexPath.row], attr_flg: self.attr_flg, supplierId: self.supplierId)
			cell.parent = self
			return cell
		}
		else {
			// 分数セル
			// 画像無しセル
			let cell = HDZItemStaticFractionNoimageCell.dequeueReusableCell(tableView: tableView, forIndexPath: indexPath, staticItem: self.displayItemList[indexPath.row], attr_flg: self.attr_flg, supplierId: self.supplierId)
			cell.parent = self
			return cell
		}
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		// 整数かどうかチェック
		var isInt: Bool = true
		for numScale: String in self.displayItemList[indexPath.row].num_scale {
			if let _: Int = Int(numScale) {
				//整数
			} else {
				//分数
				isInt = false
			}
		}
		
		if isInt {
			// 整数セル
			return HDZItemStaticNoimageCell.getHeight()
		}
		return HDZItemStaticFractionNoimageCell.getHeight()
	}
}

extension HDZItemOrderdHistoryTableViewController {
	
    internal class func createViewController(supplierId:String, attr_flg:AttrFlg) -> HDZItemOrderdHistoryTableViewController {
        let controller: HDZItemOrderdHistoryTableViewController = UIViewController.createViewController(name: "HDZItemOrderdHistoryTableViewController")
        
        controller.supplierId = supplierId
        controller.attr_flg = attr_flg
//        controller.categoryName = categoryName
//        controller.categoryKey = categoryKey
        
        return controller
    }

}
