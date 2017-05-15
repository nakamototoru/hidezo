//
//  HDZItemCheckTableViewController.swift
//  buyer
//
//  Created by Shun Nakahara on 8/1/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class HDZItemCheckTableViewController: UITableViewController {

	@IBOutlet weak var barbuttonitemConfirm: UIBarButtonItem!
	@IBOutlet weak var barbuttonitemHome: UIBarButtonItem!
	
	var supplierId: String = ""
	var request: Alamofire.Request? = nil
	var orderResult: Results<HDZOrder>? = nil

	// !!!: dezami
	var indicatorView:CustomIndicatorView!
	var itemResult: ItemResult! = nil
	var dynamicItems: [DynamicItem] = []
	var attr_flg: AttrFlg = .other
	var staticItems:[StaticItem] = []

	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "注文内容確認"
		
        HDZItemCheckCell.register(tableView: self.tableView)
		HDZItemCheckFractionCell.register(tableView: self.tableView)
		
		//インジケーター
		self.indicatorView = CustomIndicatorView.createView(framesize: self.view.frame.size)
		self.view.addSubview(self.indicatorView)
		
		// Realm（ローカルSQL）
//        self.loadItem()
		
		// ボタン無効
		self.updateButtonEnabled(enabled: false)
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		self.request?.resume()
		
		// Realm（ローカルSQL）
		self.orderResult = try! HDZOrder.queries(supplierId: self.supplierId)

		// !!!:デザミシステム
		if self.orderResult?.count == 0 {
			// アイテム無しの場合
			self.updateButtonEnabled(enabled: false)
			self.openAlertNoCart()
			
			return
		}

		// API
		self.getItem(supplierId: self.supplierId)
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
	
	// ボタン状態
	func updateButtonEnabled(enabled:Bool) {
		self.barbuttonitemConfirm.isEnabled = enabled
		self.barbuttonitemHome.isEnabled = enabled
	}
}

// MARK: - Create
extension HDZItemCheckTableViewController {
    
    internal class func createViewController(supplierId: String) -> HDZItemCheckTableViewController {
        let controller: HDZItemCheckTableViewController = UIViewController.createViewController(name: "HDZItemCheckTableViewController")
        controller.supplierId = supplierId
        return controller
    }

}

// MARK: - API
extension HDZItemCheckTableViewController {
	
	func getItem(supplierId: String) {
		
		// インジケーター開始
		self.indicatorView.startAnimating()
		
		// ボタン無効
		self.updateButtonEnabled(enabled: false)
		
		let completion: (_ unboxable: ItemResult?) -> Void = { (unboxable) in
			
			self.request = nil
			guard let result: ItemResult = unboxable else {
				return
			}
			self.itemResult = result
			// 動的アイテム登録
			if result.dynamicItems != nil {
				self.dynamicItems = result.dynamicItems!
			}
			// 静的商品登録
			if result.staticItems != nil {
				self.staticItems = result.staticItems!
			}
			
			// カートチェック
			for order:HDZOrder in self.orderResult! {
				// 動的から
				var isEqual:Bool = false
				for item:DynamicItem in self.dynamicItems {
					if order.itemId == item.id {
						isEqual = true
						break;
					}
				}
				if (isEqual) {
					// 見つかったので次へ
					continue
				}
				
				// 見つからなかったら静的を
				for item:StaticItem in self.staticItems {
					if order.itemId == item.id {
						isEqual = true
						break;
					}
				}
				if (isEqual) {
					// 見つかったので次へ
					continue
				}

				// 存在しない商品だった場合は削除
				#if DEBUG
					debugPrint("存在しない静的商品：ID=" + order.id)
				#endif
				try! HDZOrder.deleteObject(object: order)
			}
			
			// カート更新
			self.orderResult = try! HDZOrder.queries(supplierId: self.supplierId)
			//テーブル更新
			self.tableView.reloadData()

			// インジケーター停止
			self.indicatorView.stopAnimating()

			if self.orderResult?.count == 0 {
				// アイテム無しの場合
				self.openAlertNoCart()
				
				return
			}
			
			// ボタン有効
			self.updateButtonEnabled(enabled: true)
		}
		
		let error: (_ error: Error?, _ unboxable: ItemError?) -> Void = { (error, unboxable) in
			
			self.indicatorView.stopAnimating()
			self.request = nil
		}
		// Request
		self.request = HDZApi.item(supplierId: supplierId, completionBlock: completion, errorBlock: error)
	}

}

// MARK: - Table view data source
extension HDZItemCheckTableViewController {
    
//	override func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
//        return 1
//    }
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
    
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.orderResult == nil {
            return 0
        } else {
            return self.orderResult!.count
        }
    }
    
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
        if let item: HDZOrder = self.orderResult?[indexPath.row] {

			// 整数かどうかチェック
			if let _: Int = Int(item.size) {
				//整数
				let cell: HDZItemCheckCell = HDZItemCheckCell.dequeueReusableCell(tableView: tableView, indexPath: indexPath, delegate: self)
				
				cell.parent = self
				cell.indexText.text = String(format: "%d", indexPath.row + 1)
				cell.order = item
				cell.titleLabel.text = item.name
				cell.sizeLabel.text = item.size
				
				return cell
			}
			else {
				//分数
				let cell: HDZItemCheckFractionCell = HDZItemCheckFractionCell.dequeueReusableCell(tableView: tableView, indexPath: indexPath, delegate: self)
				
				cell.parent = self
				cell.indexText.text = String(format: "%d", indexPath.row + 1)
				cell.order = item
				cell.titleLabel.text = item.name
				cell.sizeLabel.text = item.size
				
				return cell
			}
        }
		else {
			return HDZItemCheckCell.dequeueReusableCell(tableView: tableView, indexPath: indexPath, delegate: self)
		}
    }
	
//	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//		
//		return HDZItemCheckCell.getHeight()
//	}
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return HDZItemCheckCell.getHeight()
	}

}

// MARK: - Order
extension HDZItemCheckTableViewController {
	
	func openAlertNoCart() {
		
		// アラートビュー
		let action2:UIAlertAction = UIAlertAction(title: "戻る", style: .default, handler: { (action:UIAlertAction!) in
			// 画面戻る
			self.navigationController?.popViewController(animated: false)
		})
		let controller: UIAlertController = UIAlertController(title: "商品が選択されていません", message: "", preferredStyle: .alert)
		controller.addAction(action2)
		self.present(controller, animated: false, completion: nil)
	}

}

// MARK: - HDZItemCheckCellDelegate
extension HDZItemCheckTableViewController: HDZItemCheckCellDelegate {

	func itemcheckcellReload() {
		
//		self.loadItem()
		self.orderResult = try! HDZOrder.queries(supplierId: self.supplierId)
		self.tableView.reloadData()
		
		// !!!:デザミシステム
		if self.orderResult?.count == 0 {
			// アイテム無しの場合
			let action2:UIAlertAction = UIAlertAction(title: "戻る", style: .default, handler: { (action:UIAlertAction!) in
				self.navigationController?.popViewController(animated: false)
			})
			let controller: UIAlertController = UIAlertController(title: "商品が選択されていません", message: "", preferredStyle: .alert)
			controller.addAction(action2)
			self.present(controller, animated: false, completion: nil)
		}
	}
}

// MARK: - Action
extension HDZItemCheckTableViewController {
	
	@IBAction func onConfirmOrder(_ sender: Any) {

		// 入力画面
		let controller:HDZItemOrderDialogViewController = HDZItemOrderDialogViewController.createViewController(supplierId: self.supplierId)
		controller.supplierId = self.supplierId
		self.navigationController?.pushViewController(controller, animated: true)

	}
	
	@IBAction func onBackHome(_ sender: Any) {

		// ホームに戻る
		self.navigationController?.popToViewController((self.navigationController?.viewControllers.first)!, animated: true)
	}

}
