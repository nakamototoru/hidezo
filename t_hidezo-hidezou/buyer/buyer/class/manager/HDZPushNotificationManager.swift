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
	
	func setMessageUpList(messages:[MessageUp]) {
		self.messageUpList = messages
	}
	func getMessageUpList() -> [MessageUp] {
		
		return messageUpList
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
			
			// TODO:通知バッジのリセット

		}
		let error: (error: ErrorType?, result: BadgeError?) -> Void = { (error, result) in
			// エラー処理
			debugPrint(error)
			debugPrint(result)
		}
		HDZApi.badge(completion, errorBlock: error);
	}
	
}