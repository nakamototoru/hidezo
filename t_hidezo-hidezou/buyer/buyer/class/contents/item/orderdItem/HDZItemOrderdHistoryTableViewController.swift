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

    private var request: Alamofire.Request? = nil
    private var resultOrderdItem: OrderdItemResult? = nil

    private var supplierId: String = ""
    private var attr_flg: AttrFlg = AttrFlg.direct
//    private var staticItems: [StaticItem] = []
	private var displayItemList:[DisplayStaticItem] = []

    private var indicatorView:CustomIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.title = "履歴から注文"
        
        // セル登録
//        HDZItemStaticCell.register(self.tableView)
//        HDZItemStaticFractionCell.register(self.tableView)
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

    func reloadRequest() {
        getOrderdItem(supplierId)
    }
    
    func getOrderdItem(supplierId: String) {
        
        self.refreshControl?.beginRefreshing()
        
        // インジケーター開始
        self.indicatorView.startAnimating()
		
		self.displayItemList.removeAll()
		
        let completion: (unboxable: OrderdItemResult?) -> Void = { (unboxable) in
            
            self.request = nil
            
            guard let result:OrderdItemResult = unboxable else {
                return
            }
            self.resultOrderdItem = result
            
            // JSON解析
            if let items: [OrderdStaticItem] = result.orderdStaticItems {

				debugPrint(items[0])
				
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
			
            // 静的商品の登録
            //            self.categoryItems = [:]
            //            if let staticItems: [StaticItem] = result.staticItem {
            //                for staticItem in staticItems {
            //                    let index:Int = Int(staticItem.category.id)!
            //
            //                    if self.categoryItems[ index ] == nil {
            //                        self.categoryItems[ index ] = [staticItem]
            //                    } else {
            //                        self.categoryItems[ index ]?.append(staticItem)
            //                    }
            //                }
            //            }
            //            self.staticItems = self.categoryItems[ self.categoryKey ]!
            // End
            
            //            
            self.indicatorView.stopAnimating()
            self.refreshControl?.endRefreshing()
            // 再描画
            self.tableView.reloadData()
        }
        
        let error: (error: ErrorType?, unboxable: ItemError?) -> Void = { (error, unboxable) in
            
            self.indicatorView.stopAnimating()
            self.refreshControl?.endRefreshing()
            self.request = nil
        }
        
        // Request
        self.request = HDZApi.orderd_item(supplierId, completionBlock: completion, errorBlock: error)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.request?.resume()

        getOrderdItem(supplierId)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.request?.suspend()
    }
    
    deinit {
        self.request?.cancel()
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.displayItemList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
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
            let cell = HDZItemStaticNoimageCell.dequeueReusableCell(tableView, forIndexPath: indexPath, staticItem: self.displayItemList[indexPath.row], attr_flg: self.attr_flg, supplierId: self.supplierId)
            cell.parent = self
            return cell
        }
        else {
            // 分数セル
            // 画像無しセル
            let cell = HDZItemStaticFractionNoimageCell.dequeueReusableCell(tableView, forIndexPath: indexPath, staticItem: self.displayItemList[indexPath.row], attr_flg: self.attr_flg, supplierId: self.supplierId)
            cell.parent = self
            return cell
        }
    }

	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HDZItemOrderdHistoryTableViewController {
    
    internal class func createViewController(supplierId:String, attr_flg:AttrFlg) -> HDZItemOrderdHistoryTableViewController {
        let controller: HDZItemOrderdHistoryTableViewController = UIViewController.createViewController("HDZItemOrderdHistoryTableViewController")
        
        controller.supplierId = supplierId
        controller.attr_flg = attr_flg
//        controller.categoryName = categoryName
//        controller.categoryKey = categoryKey
        
        return controller
    }

}
