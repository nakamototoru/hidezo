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

    private var orderInfo: OrderInfo! = nil
    private var orderDetailRequest: Alamofire.Request? = nil
    
    private var attr_flg: AttrFlg = .other
    private lazy var orderDetailItems: [OrderDetailItem] = []
	
//	var viewBadge:HDZBadgeView! = nil

    private var textSubTotal:String = ""
    private var textPostage:String = ""
    private var textTotal:String = ""
    private var textCharge:String = ""
    private var textDeliverdDay:String = ""
    private var textDeliverdPlace:String = ""
	
    private var requestMessage: Alamofire.Request? = nil
    private var messageResult: MessageResult! = nil
    private lazy var messageList: [MessageInfo] = []

    // インジケータ
    private var indicatorView:CustomIndicatorView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        self.deleteBackButtonTitle()
		
		self.title = self.orderInfo.supplier_name + "様宛"
		
		// ナビゲーション右ボタン
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: #selector(didSelectedCommentCreate(_:)))
		
		// セル登録
        HDZOrderDetailCell.register(self.tableView)
        HDZOrderDetailResultCell.register(self.tableView)
        HDZCommentCell.register(self.tableView)
        
        // テーブル更新ゼスチャー
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadRequest), forControlEvents: .ValueChanged)
        self.refreshControl = refreshControl

        // フッター登録
        //        self.tableView.tableFooterView = HDZOrderDetailFooter.createView()

//        self.tableView.rowHeight = UITableViewAutomaticDimension
//        self.tableView.estimatedRowHeight = 113.0
		
        //インジケータ生成
        self.indicatorView = CustomIndicatorView.createView(self.view.frame.size)
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
        let controller:HDZCommentFormNavigation = HDZCommentFormNavigation.createViewController(self.messageResult, order_no: self.orderInfo.order_no)
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		// !!!:バッジ通知
//		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(getNotification(_:)), name: HDZPushNotificationManager.shared.strNotificationMessage, object: nil)
	}
	
    override func viewDidAppear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.orderDetailRequest?.resume()
//        self.requestMessage?.resume()
		
        // メッセージだけ
        self.apiRequestMessage()
    }
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)

		// API中断
		self.orderDetailRequest?.suspend()
		self.requestMessage?.suspend()

		//イベントリスナーの削除
		NSNotificationCenter.defaultCenter().removeObserver(self)
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
		NSNotificationCenter.defaultCenter().removeObserver(self)
    }

	// !!!:通知受け取り時
//	func getNotification(notification: NSNotification)  {
//		
////		updateBadgeMessage()
//	}
	
//	func didSelectedMessage(button: UIBarButtonItem) {
//		
//		let controller: HDZCommentTableViewController = HDZCommentTableViewController.createViewController(self.orderInfo)
//		self.navigationController?.pushViewController(controller, animated: true)
//	}

//	func putBadge(value: Int) {
//		
//		// !!!バッジビュー
////		if self.viewBadge == nil {
////			let statusBarHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.height	// ステータスバーの高さを取得
////			
////			let badgepos: CGPoint = CGPointMake(self.view.frame.size.width, statusBarHeight)
////			let anchor:CGPoint = CGPointMake(1, 0)
////			self.viewBadge = HDZBadgeView.createWithPosition(badgepos, anchor:anchor)
////			self.navigationController?.view.addSubview(self.viewBadge)
////		}
////		self.viewBadge.updateBadge(value)
//	}
//	
//	func updateBadgeMessage() {
//		
//		// バッジ・メッセージ更新
////		let list:[MessageUp] = HDZPushNotificationManager.shared.getMessageUpList()
////		var badgeValue:Int = 0
////		for obj:MessageUp in list {
////			let order_no:String = obj.order_no
////			if order_no == orderInfo.order_no {
////				badgeValue = obj.messageCount
////				break
////			}
////		}
////		putBadge(badgeValue)
//	}

}

// MARK: - Table view data source
extension HDZOrderDetailTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.section == 2 {
            let messageInfo: MessageInfo = self.messageList[indexPath.row]
            let customcell = HDZCommentCell.dequeueReusable(tableView, indexPath: indexPath, messageInfo: messageInfo, maxIndex: self.messageList.count)
            customcell.parent = self
            return customcell
        }
        
        if indexPath.section == 1 {
            let customcell = HDZOrderDetailResultCell.dequeueReusableCell(self, tableView: tableView, for: indexPath)
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
        let cell = HDZOrderDetailCell.dequeueReusableCell(self, tableView: tableView, for: indexPath, orderDetailItem: orderDetailItem, attr_flg: self.attr_flg)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 2 {
            
        }
        else if indexPath.section == 0 {
            let orderDetailItem: OrderDetailItem = self.orderDetailItems[indexPath.row]
            let controller: HDZOrderItemTableViewController = HDZOrderItemTableViewController.createViewController(orderDetailItem)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
				
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
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        if section == 2 {
            return String(format: "%d件のコメントがあります。", self.messageList.count)
        }
        else if section == 1 {
            return "統計"
        }
        return "商品"
    }
}

// MARK: - Create
extension HDZOrderDetailTableViewController {
    
    internal class func createViewController(orderInfo: OrderInfo) -> HDZOrderDetailTableViewController {
        let controller: HDZOrderDetailTableViewController = UIViewController.createViewController("HDZOrderDetailTableViewController")
        controller.orderInfo = orderInfo
        return controller
    }
}

// MARK: - private
extension HDZOrderDetailTableViewController {
    
    private func apiOrderDetail() {
        
        let completion: (unboxable: OrderDetailResult?) -> Void = { (unboxable) in
            
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
			self.textDeliverdDay = result.delivery_day
			self.textDeliverdPlace = result.deliver_to
			
            // Api
//            self.apiRequestMessage()
        }
        
        let error: (error: ErrorType?, result: OrderDetailError?) -> Void = { (error, result) in
            //インジケーター停止
            self.indicatorView.stopAnimating()
        }
        
        // インジケーター開始
        self.indicatorView.startAnimating()

        self.orderDetailRequest = HDZApi.orderDitail(self.orderInfo.order_no, completionBlock: completion, errorBlock: error)
    }
	
//	private func priceValue(price: String, order_num: String, attr_flg: AttrFlg) -> Int {
//		
//		let prices: [String] = price.componentsSeparatedByString(",")
//		if prices.count < 1 {
//			return 0
//		}
//		
//		if prices.count == 1 {
//			guard let price: Int = Int(prices[0]) else {
//				return 0
//			}
//			
//			guard let orderNum: Int = Int(order_num) else {
//				return 0
//			}
//			
//			return price * orderNum
//		} else {
//			guard let orderNum: Int = Int(order_num) else {
//				return 0
//			}
//			
//			switch attr_flg {
//			case .direct:
//				guard let price: Int = Int(prices[2]) else {
//					return 0
//				}
//				
//				return price * orderNum
//			case .group:
//				guard let price: Int = Int(prices[1]) else {
//					return 0
//				}
//				
//				return price * orderNum
//			case .other:
//				
//				guard let price: Int = Int(prices[0]) else {
//					return 0
//				}
//				
//				return price * orderNum
//			}
//		}
//	}

    private func apiRequestMessage() {
        
        self.refreshControl?.beginRefreshing()
        
        let completion: (unboxable: MessageResult?) -> Void = { (unboxable) in
            
            //インジケーター停止
            self.indicatorView.stopAnimating()

            self.refreshControl?.endRefreshing()
            
            guard let result: MessageResult = unboxable else {
                return
            }
            
            self.requestMessage = nil
            
            self.messageResult = result
            self.messageList = result.messageList.reverse()
            
            self.tableView.reloadData()
            
            // !!!:dezami・バッジ消去
            HDZPushNotificationManager.shared.removeMessageUp(self.orderInfo.order_no)
			// TODO:クラッシュ発生
            HDZPushNotificationManager.updateMessageBadgeWithController(self)
            HDZPushNotificationManager.updateBadgeInHomeIcon()
        }
        
        let error: (error: ErrorType?, result: MessageError?) -> Void = { (error, unboxable) in
            //インジケーター停止
            self.indicatorView.stopAnimating()

            self.refreshControl?.endRefreshing()
        }
        
        // インジケーター開始
        self.indicatorView.startAnimating()

        self.requestMessage = HDZApi.message(self.orderInfo.order_no, completionBlock: completion, errorBlock: error)
    }

}

// MARK: - UIPopoverPresentationControllerDelegate
extension HDZOrderDetailTableViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .None
    }
}

// MARK: - HDZCommentCreateViewControllerDelegate
//extension HDZOrderDetailTableViewController: HDZCommentCreateViewControllerDelegate {
//    func requestUpdate() {
//        self.apiRequestMessage()
//    }
//}
