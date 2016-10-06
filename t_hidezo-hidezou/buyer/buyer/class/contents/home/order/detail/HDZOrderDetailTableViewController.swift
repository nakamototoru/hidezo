//
//  HDZOrderDetailTableViewController.swift
//  seller
//
//  Created by NakaharaShun on 6/21/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire

class HDZOrderDetailTableViewController: UITableViewController {

    private var orderInfo: OrderInfo! = nil
    private var orderDetailRequest: Alamofire.Request? = nil
    
    private var attr_flg: AttrFlg = .other
    private lazy var orderDetailItems: [OrderDetailItem] = []
	
	var viewBadge:HDZBadgeView! = nil

	
    override func viewDidLoad() {
        super.viewDidLoad()

        self.deleteBackButtonTitle()
		
//        self.navigationItem.prompt = self.orderInfo.supplier_name + "様宛"
		self.title = self.orderInfo.supplier_name + "様宛"
		
		// ナビゲーション右ボタン
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "コメント", style: .Done, target: self, action: #selector(HDZOrderDetailTableViewController.didSelectedMessage(_:)))
		
		// セル登録
        HDZOrderDetailCell.register(self.tableView)
        
        self.tableView.tableFooterView = HDZOrderDetailFooter.createView()

//        self.tableView.rowHeight = UITableViewAutomaticDimension
//        self.tableView.estimatedRowHeight = 113.0

		// !!!:バッジ通知
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HDZOrderDetailTableViewController.getNotification(_:)), name: HDZPushNotificationManager.shared.strNotificationMessage, object: nil)
		
		// API
        self.orderDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
    override func viewDidAppear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.orderDetailRequest?.resume()

		// !!!:バッジ表示
		self.updateBadgeMessage()

    }
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		
		// !!!:バッジ隠す
		self.putBadge(-1)
	}
	
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.orderDetailRequest?.suspend()
    }
    
    deinit {
        self.orderDetailRequest?.cancel()
		
		//イベントリスナーの削除
		NSNotificationCenter.defaultCenter().removeObserver(self)
    }

	// !!!:通知受け取り時
	func getNotification(notification: NSNotification)  {
		
		//self.tableView.reloadData()
		self.updateBadgeMessage()
	}
}

extension HDZOrderDetailTableViewController {
	
	func putBadge(value: Int) {
		
		// !!!バッジビュー
		if self.viewBadge == nil {
			let statusBarHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.height	// ステータスバーの高さを取得

			let badgepos: CGPoint = CGPointMake(self.view.frame.size.width, statusBarHeight)
			let anchor:CGPoint = CGPointMake(1, 0)
			self.viewBadge = HDZBadgeView.createWithPosition(badgepos, anchor:anchor)
			self.navigationController?.view.addSubview(self.viewBadge)
		}
		self.viewBadge.updateBadge(value)
	}
	
	func updateBadgeMessage() {
		
		// バッジ・メッセージ更新
		let list:[MessageUp] = HDZPushNotificationManager.shared.getMessageUpList()
		var badgeValue:Int = 0
		for obj:MessageUp in list {
			let order_no:String = obj.order_no
			if order_no == orderInfo.order_no {
				badgeValue = obj.messageCount
				break
			}
		}
		self.putBadge(badgeValue)
	}

}

// MARK: - Table view data source
extension HDZOrderDetailTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.orderDetailItems.count
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let orderDetailItem: OrderDetailItem = self.orderDetailItems[indexPath.row]
        let cell = HDZOrderDetailCell.dequeueReusableCell(self, tableView: tableView, for: indexPath, orderDetailItem: orderDetailItem, attr_flg: self.attr_flg)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let orderDetailItem: OrderDetailItem = self.orderDetailItems[indexPath.row]
        let controller: HDZOrderItemTableViewController = HDZOrderItemTableViewController.createViewController(orderDetailItem)
        self.navigationController?.pushViewController(controller, animated: true) // true
    }
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
				
		return HDZOrderDetailCell.getHeight()
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
    
    private func orderDetail() {
        
        let completion: (unboxable: OrderDetailResult?) -> Void = { (unboxable) in
            guard let result: OrderDetailResult = unboxable else {
                return
            }
            
            self.orderDetailRequest = nil
            
            self.orderDetailItems += result.staicItemList
            self.orderDetailItems += result.dynamicItemList
            self.attr_flg = result.attr_flg
			
			// !!!:デザミ
			// 計算
			let footer: HDZOrderDetailFooter = self.tableView.tableFooterView as! HDZOrderDetailFooter
			footer.subtotalLabel.text = "\(result.subtotal)" + "円"
			footer.postageLabel.text = String(result.deliveryFee) + "円"
			footer.totalLabel.text = String(result.total) + "円"
			// 注文情報
			footer.chargeLabel.text = result.charge
			footer.deliveredLabel.text = result.delivery_day
			footer.deliveredPlaceLabel.text = result.deliver_to
			
            self.tableView.reloadData()
        }
        
        let error: (error: ErrorType?, result: OrderDetailError?) -> Void = { (error, result) in
            
        }
        
        self.orderDetailRequest = HDZApi.orderDitail(self.orderInfo.order_no, completionBlock: completion, errorBlock: error)
    }
	
	private func priceValue(price: String, order_num: String, attr_flg: AttrFlg) -> Int {
		
		let prices: [String] = price.componentsSeparatedByString(",")
		if prices.count < 1 {
			return 0
		}
		
		
		if prices.count == 1 {
			guard let price: Int = Int(prices[0]) else {
				return 0
			}
			
			guard let orderNum: Int = Int(order_num) else {
				return 0
			}
			
			return price * orderNum
		} else {
			guard let orderNum: Int = Int(order_num) else {
				return 0
			}
			
			switch attr_flg {
			case .direct:
				guard let price: Int = Int(prices[2]) else {
					return 0
				}
				
				return price * orderNum
			case .group:
				guard let price: Int = Int(prices[1]) else {
					return 0
				}
				
				return price * orderNum
			case .other:
				
				guard let price: Int = Int(prices[0]) else {
					return 0
				}
				
				return price * orderNum
			}
		}
	}

}

// MARK: - action
extension HDZOrderDetailTableViewController {
	
    @IBAction func didSelectedMessage(button: UIBarButtonItem) {
		
//		// バッジ消去
//		HDZPushNotificationManager.shared.removeMessageUp(self.orderInfo.order_no)
//		let messageList:[MessageUp] = HDZPushNotificationManager.shared.getMessageUpList()
//		if messageList.count > 0 {
//			self.tabBarController?.tabBar.items![1].badgeValue = String(messageList.count) // 下階層から呼ぶ場合
//		}
//		else {
//			self.tabBarController?.tabBar.items![1].badgeValue = nil // 下階層から呼ぶ場合
//		}
		
        let controller: HDZCommentTableViewController = HDZCommentTableViewController.createViewController(self.orderInfo)
        self.navigationController?.pushViewController(controller, animated: true)
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
