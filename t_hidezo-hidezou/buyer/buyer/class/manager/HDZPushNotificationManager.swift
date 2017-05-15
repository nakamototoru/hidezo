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
	
	var strNotificationSupplier = Notification.Name("notofication_supplier")
	var strNotificationMessage = Notification.Name("notofication_message")
	
//	static var arrayPushAps:[PushApsResult] = []
//	static var isDialogOpened:Bool = false
	
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
		var loop:Int = 0;
		for item:SupplierId in supplierUpList {
			if item.supplierId == supplier_id {
				supplierUpList.remove(at: loop)
				break
			}
			loop += 1;
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
	func removeMessageUp(order_no:String) -> Int {
		var result:Int = 0;
		var loop:Int = 0;
		for item:MessageUp in messageUpList {
			if item.order_no == order_no {
				messageUpList.remove(at: loop)
				result = item.messageCount
				break;
			}
			loop += 1
		}
		return result
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
		
		let completion: (_ unboxable: BadgeResult?) -> Void = { (unboxable) in
			#if DEBUG
				debugPrint(unboxable.debugDescription)
			#endif
			
			var strResult:String = ""
			
			// 商品更新
			let supplierList: [SupplierId] = (unboxable?.supplierUp.supplierUpList)!
			HDZPushNotificationManager.shared.setSupplierUpList( suppliers: supplierList )
			// ローカル通知
			let n = Notification(name: HDZPushNotificationManager.shared.strNotificationSupplier, object: self, userInfo: ["value": 10])
			NotificationCenter.default.post(n)
			
			strResult += "supplierUpList {\n"
			for object:SupplierId in (unboxable?.supplierUp.supplierUpList)! {
				strResult += "    supplierId : "
				strResult += object.supplierId
				strResult += "\n"
			}
			strResult += "}\n"
			
			// メッセージ更新
			//					let messageUp:CustomDataMessageUpResult = customData.messageUp
			let messageList: [MessageUp] = (unboxable?.messageUp.messageUpList)!
			HDZPushNotificationManager.shared.setMessageUpList( messages: messageList )
			// ローカル通知
			let nMes = Notification(name: HDZPushNotificationManager.shared.strNotificationMessage, object: self, userInfo: ["value": 10])
			NotificationCenter.default.post(nMes)
			
			strResult += "messageUpList {\n"
			for object:MessageUp in (unboxable?.messageUp.messageUpList)! {
				strResult += "{\n"
				
				strResult += "order_no : "
				strResult += object.order_no
				strResult += "\n"
				
				strResult += "messageCount : "
				strResult += String( object.messageCount )
				strResult += "\n"
				
				strResult += "}\n"
			}
			strResult += "}\n"
			
//			UIWarning.WarningWithTitle("開発・バッジ情報", message: strResult)
		}
		let error: (_ error: Error?, _ result: BadgeError?) -> Void = { (error, result) in
			// エラー処理
			debugPrint(error.debugDescription)
			debugPrint(result.debugDescription)
		}
		let _ = HDZApi.badge(completionBlock: completion, errorBlock: error);
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
		
		// OSバッジ
		updateBadgeInHomeIcon()

//		openDialog()
	}
	internal class func updateSupplierBadge(controller:UIViewController) {
		
		updateSupplierBadgeWithTabBar(tabBar: controller.tabBarController!.tabBar)
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

		// OSバッジ
		updateBadgeInHomeIcon()

//		openDialog()
	}
	internal class func updateMessageBadgeWithController(controller:UIViewController) {
		
		updateMessageBadgeWithTabBar(tabBar: controller.tabBarController!.tabBar)
	}
	
	// OSバッジ数
	internal class func updateApplicationBadge(count:Int) {
		
		UIApplication.shared.applicationIconBadgeNumber = count
		if count <= 0 {
			UIApplication.shared.cancelAllLocalNotifications()
			UIApplication.shared.applicationIconBadgeNumber = -1
		}
	}
//	internal class func decApplicationBadge(delta:Int) {
//		var count:Int = UIApplication.sharedApplication().applicationIconBadgeNumber
//		count -= delta
//		updateApplicationBadge(count)
//	}
	
	internal class func updateBadgeInHomeIcon() {
		
		var count:Int = 0
		count += HDZPushNotificationManager.shared.getSupplierUpCount()
		count += HDZPushNotificationManager.shared.getMessageUpCount()
		updateApplicationBadge(count: count)
	}
	
	// スタック追加
//	internal class func appendPushAps(pushAps:PushApsResult) {
//		if arrayPushAps.count < 1000 {
//			arrayPushAps.append(pushAps)
//		}
//	}
	
	// 通知ダイアログ開く
//	internal class func openDialog() {
//		if let pushAps:PushApsResult = arrayPushAps.first {
//			UIWarning.Warning(pushAps.alert)
//			arrayPushAps.removeAll()
//		}
//	}
}
