//
//  HDZPushNotificationManager.swift
//  buyer
//
//  Created by デザミ on 2016/08/30.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZPushNotificationManager: NSObject {

	private var supplierUpList:[SupplierId] = []
	private var messageUpList:[MessageUp] = []
	
	var strNotificationSupplier:String = "notofication_supplier"
	var strNotificationMessage:String = "notofication_message"
	
	static let shared = HDZPushNotificationManager()
	private override init() {
	}

	func setSupplierUpList(suppliers:[SupplierId]) {
		self.supplierUpList = suppliers
	}
	func getSupplierUpList() -> [SupplierId] {
		return supplierUpList
	}
	func removeSupplierUp(supplier_id:String) {
		var count:Int = 0;
		for item:SupplierId in supplierUpList {
			if item.supplierId == supplier_id {
				supplierUpList.removeAtIndex(count)
				break
			}
			count += 1;
		}
	}
	func removeSupplierUpAll() {
		supplierUpList.removeAll()
	}
	func getSupplierUpCount() -> Int {
		var count:Int = 0;
		for item:SupplierId in supplierUpList {
			if item.supplierId != "" {
				count += 1;
			}
		}
		return count
	}
	
	func setMessageUpList(messages:[MessageUp]) {
		self.messageUpList = messages
	}
	func getMessageUpList() -> [MessageUp] {
		return messageUpList
	}
	func removeMessageUp(order_no:String) {
		var count:Int = 0;
		for item:MessageUp in messageUpList {
			if item.order_no == order_no {
				messageUpList.removeAtIndex(count)
				break;
			}
			count += 1
		}
	}
	func removeMessageUpAll() {
		messageUpList.removeAll()
	}
	func getMessageUpCount() -> Int {
		var count:Int = 0
		for obje:MessageUp in messageUpList {
			
			let num:Int = obje.messageCount
			count += num
		}
		return count
	}
}

extension HDZPushNotificationManager {
	
	internal class func checkBadge() {
		
		let completion: (unboxable: BadgeResult?) -> Void = { (unboxable) in
			#if DEBUG
				debugPrint(unboxable)
			#endif
			
			// 商品更新
			let supplierList: [SupplierId] = (unboxable?.supplierUp.supplierUpList)!
			HDZPushNotificationManager.shared.setSupplierUpList( supplierList )
			//NSNotification
			let n : NSNotification = NSNotification(name: HDZPushNotificationManager.shared.strNotificationSupplier, object: self, userInfo: ["value": 10])
			NSNotificationCenter.defaultCenter().postNotification(n)
			
			// メッセージ更新
			//					let messageUp:CustomDataMessageUpResult = customData.messageUp
			let messageList: [MessageUp] = (unboxable?.messageUp.messageUpList)!
			HDZPushNotificationManager.shared.setMessageUpList( messageList )
			//NSNotification
			let nMes : NSNotification = NSNotification(name: HDZPushNotificationManager.shared.strNotificationMessage, object: self, userInfo: ["value": 10])
			NSNotificationCenter.defaultCenter().postNotification(nMes)
			
		}
		let error: (error: ErrorType?, result: BadgeError?) -> Void = { (error, result) in
			// エラー処理
			debugPrint(error)
			debugPrint(result)
		}
		HDZApi.badge(completion, errorBlock: error);
	}
	
	// タブバー更新
	// 商品
	internal class func updateSupplierBadgeWithTabBar(tabBar:UITabBar) {
		
		let count:Int = HDZPushNotificationManager.shared.getSupplierUpCount()
		if count > 0 {
			tabBar.items![0].badgeValue = String(count)
		}
		else {
			tabBar.items![0].badgeValue = nil
		}
	}
	internal class func updateSupplierBadge(controller:UIViewController) {
		
		updateSupplierBadgeWithTabBar(controller.tabBarController!.tabBar)
	}
	
	// メッセージ
	internal class func updateMessageBadgeWithTabBar(tabBar:UITabBar) {
		
		let count:Int = HDZPushNotificationManager.shared.getMessageUpCount()
		if count > 0 {
			tabBar.items![1].badgeValue = String(count)
		}
		else {
			tabBar.items![1].badgeValue = nil
		}
	}
	internal class func updateMessageBadgeWithController(controller:UIViewController) {
		
		updateMessageBadgeWithTabBar(controller.tabBarController!.tabBar)
	}
}