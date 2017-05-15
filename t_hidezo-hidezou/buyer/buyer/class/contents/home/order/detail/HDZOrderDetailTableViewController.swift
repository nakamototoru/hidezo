//
//  HDZOrderDetailTableViewController.swift
//  seller
//
//  Created by NakaharaShun on 6/21/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire
import Unbox

class HDZOrderDetailTableViewController: UITableViewController {

	var orderInfo: OrderInfo! = nil
	var orderDetailRequest: Alamofire.Request? = nil
    
	var attr_flg: AttrFlg = .other
	lazy var orderDetailItems: [OrderDetailItem] = []
	
//	var viewBadge:HDZBadgeView! = nil

	var textSubTotal:String = ""
	var textPostage:String = ""
	var textTotal:String = ""
	var textCharge:String = ""
	var textDeliverdDay:String = ""
	var textDeliverdPlace:String = ""
	
	var requestMessage: Alamofire.Request? = nil
	var messageResult: MessageResult! = nil
	lazy var messageList: [MessageInfo] = []

    // インジケータ
	var indicatorView:CustomIndicatorView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        self.deleteBackButtonTitle()
		
		self.title = self.orderInfo.supplier_name + "様宛"
		
		// ナビゲーション右ボタン
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didSelectedCommentCreate))
		
		// セル登録
        HDZOrderDetailCell.register(tableView: self.tableView)
        HDZOrderDetailResultCell.register(tableView: self.tableView)
        HDZCommentCell.register(tableView: self.tableView)
        
        // テーブル更新ゼスチャー
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadRequest), for: .valueChanged)
        self.refreshControl = refreshControl

        // フッター登録
        //        self.tableView.tableFooterView = HDZOrderDetailFooter.createView()

//        self.tableView.rowHeight = UITableViewAutomaticDimension
//        self.tableView.estimatedRowHeight = 113.0
		
        //インジケータ生成
        self.indicatorView = CustomIndicatorView.createView(framesize: self.view.frame.size)
        self.view.addSubview(self.indicatorView)

		// API
        self.apiOrderDetail()
    }

    func reloadRequest() {
        // メッセージだけ更新
        self.apiRequestMessage()
    }
    func didSelectedCommentCreate(barButtonItem: UIBarButtonItem) {
        // メッセージ作成画面        
        let controller:HDZCommentFormNavigation = HDZCommentFormNavigation.createViewController(messageResult: self.messageResult, order_no: self.orderInfo.order_no)
        self.present(controller, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// !!!:バッジ通知
//		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(getNotification(_:)), name: HDZPushNotificationManager.shared.strNotificationMessage, object: nil)
	}
	
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.orderDetailRequest?.resume()
//        self.requestMessage?.resume()
		
        // メッセージだけ
        self.apiRequestMessage()
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		// API中断
		self.orderDetailRequest?.suspend()
		self.requestMessage?.suspend()

		//イベントリスナーの削除
		NotificationCenter.default.removeObserver(self)
	}
	
//    override func viewDidDisappear(animated: Bool) {
//        super.viewDidDisappear(animated)
//        
////        self.orderDetailRequest?.suspend()
////        self.requestMessage?.suspend()
//    }
	
    deinit {
        self.orderDetailRequest?.cancel()
        self.requestMessage?.cancel()
		
		//イベントリスナーの削除
		NotificationCenter.default.removeObserver(self)
    }

}

// MARK: - Table view data source
extension HDZOrderDetailTableViewController {
	
	override func numberOfSections(in tableView: UITableView) -> Int {
	//func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
	//func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.orderDetailItems.count
        case 1:
            return 1
        case 2:
            return self.messageList.count
        default:
            return 0
        }
    }

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	//func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.section == 2 {
            let messageInfo: MessageInfo = self.messageList[indexPath.row]
            let customcell = HDZCommentCell.dequeueReusable(tableView: tableView, indexPath: indexPath, messageInfo: messageInfo, maxIndex: self.messageList.count)
            customcell.parent = self
            return customcell
        }
        
        if indexPath.section == 1 {
            let customcell = HDZOrderDetailResultCell.dequeueReusableCell(controller: self, tableView: tableView, for: indexPath)
            customcell.subtotalLabel.text = self.textSubTotal
            customcell.postageLabel.text = self.textPostage
            customcell.totalLabel.text = self.textTotal
            customcell.chargeLabel.text = self.textCharge
            customcell.deliveredDayLabel.text = self.textDeliverdDay
            customcell.deliveredPlaceLabel.text = self.textDeliverdPlace
            return customcell
        }
        
        // indexPath.section == 0
        let orderDetailItem: OrderDetailItem = self.orderDetailItems[indexPath.row]
        let cell = HDZOrderDetailCell.dequeueReusableCell(controller: self, tableView: tableView, for: indexPath, orderDetailItem: orderDetailItem, attr_flg: self.attr_flg)
        return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	//func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 2 {
            
        }
        else if indexPath.section == 0 {
            let orderDetailItem: OrderDetailItem = self.orderDetailItems[indexPath.row]
            let controller: HDZOrderItemTableViewController = HDZOrderItemTableViewController.createViewController(orderDetailItem: orderDetailItem)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
	//func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
				
        var height:CGFloat = 0.0
        if indexPath.section == 2 {
            height = HDZCommentCell.getHeight()
        }
        else if indexPath.section == 1 {
            height = HDZOrderDetailResultCell.getHeight()
        }
        else if indexPath.section == 0 {
            height = HDZOrderDetailCell.getHeight()
        }
		return height
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
	//func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        if section == 2 {
            return String(format: "%d件のコメントがあります。", self.messageList.count)
        }
        else if section == 1 {
            return "統計"
        }
        return "商品"
    }
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		let height: CGFloat = 24.0 //super.tableView(tableView, heightForFooterInSection: section)
		return height
	}
}

// MARK: - Create
extension HDZOrderDetailTableViewController {
    
    internal class func createViewController(orderInfo: OrderInfo) -> HDZOrderDetailTableViewController {
        let controller: HDZOrderDetailTableViewController = UIViewController.createViewController(name: "HDZOrderDetailTableViewController")
        controller.orderInfo = orderInfo
        return controller
    }
}

// MARK: - private
extension HDZOrderDetailTableViewController {
    
	func apiOrderDetail() {
        
        let completion: (_ unboxable: OrderDetailResult?) -> Void = { (unboxable) in
            
            //インジケーター停止
            self.indicatorView.stopAnimating()

            guard let result: OrderDetailResult = unboxable else {
                return
            }
            
            self.orderDetailRequest = nil
            
            self.orderDetailItems += result.staicItemList
            self.orderDetailItems += result.dynamicItemList
            self.attr_flg = result.attr_flg
			
			// !!!:デザミ
            // 注文情報
			self.textSubTotal = String(result.subtotal) + "円"
			self.textPostage = String(result.deliveryFee) + "円"
			self.textTotal = String(result.total) + "円"
			self.textCharge = result.charge
			if result.delivery_day != nil {
				self.textDeliverdDay = result.delivery_day!
			}
			self.textDeliverdPlace = result.deliver_to
			
            // Api
//            self.apiRequestMessage()
        }
        
        let error: (_ error: Error?, _ result: OrderDetailError?) -> Void = { (error, result) in
            //インジケーター停止
            self.indicatorView.stopAnimating()
        }
        
        // インジケーター開始
        self.indicatorView.startAnimating()

        self.orderDetailRequest = HDZApi.orderDitail(orderNo: self.orderInfo.order_no, completionBlock: completion, errorBlock: error)
    }

	func apiRequestMessage() {
        
        self.refreshControl?.beginRefreshing()
        
        let completion: (_ unboxable: MessageResult?) -> Void = { (unboxable) in
            
            //インジケーター停止
            self.indicatorView.stopAnimating()

            self.refreshControl?.endRefreshing()
            
            guard let result: MessageResult = unboxable else {
                return
            }
            
            self.requestMessage = nil
            
            self.messageResult = result
            self.messageList = result.messageList.reversed()
            
            self.tableView.reloadData()
            
            // !!!:dezami・バッジ消去
            let _ = HDZPushNotificationManager.shared.removeMessageUp(order_no: self.orderInfo.order_no)
			// TODO:クラッシュ発生
            HDZPushNotificationManager.updateMessageBadgeWithController(controller: self)
            HDZPushNotificationManager.updateBadgeInHomeIcon()
        }
        
        let error: (_ error: Error?, _ result: MessageError?) -> Void = { (error, unboxable) in
            //インジケーター停止
            self.indicatorView.stopAnimating()

            self.refreshControl?.endRefreshing()
        }
        
        // インジケーター開始
        self.indicatorView.startAnimating()

        self.requestMessage = HDZApi.message(order_no: self.orderInfo.order_no, completionBlock: completion, errorBlock: error)
    }

}

// MARK: - UIPopoverPresentationControllerDelegate
extension HDZOrderDetailTableViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
