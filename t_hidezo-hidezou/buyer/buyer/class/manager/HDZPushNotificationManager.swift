//
//  HDZPushNotificationManager.swift
//  buyer
//
//  Created by デザミ on 2016/08/30.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZPushNotificationManager: NSObject {

	private var supplierUpList:SupplierUpListResult! = nil
	private var messageUpList:MessageUpListResult! = nil
	
	var strNotificationSupplier:String = "notofication_supplier"
	var strNotificationMessage:String = "notofication_message"
	
	static let shared = HDZPushNotificationManager()
	private override init() {
	}

	func setSupplierUpList(suppliers:SupplierUpListResult) {
		self.supplierUpList = suppliers
	}
	func getSupplierUpList() -> [SupplierId] {
		
		guard let result:SupplierUpListResult = self.supplierUpList else {
			return []
		}
		guard let list:[SupplierId] = result.supplierUpList else {
			return []
		}
		return list
	}
	
	func setMessageUpList(messages:MessageUpListResult) {
		self.messageUpList = messages
	}
	func getMessageUpList() -> [MessageUp] {
		
		guard let result:MessageUpListResult = self.messageUpList else {
			return []
		}
		guard let list:[MessageUp] = result.messageUpList else {
			return []
		}
		return list
	}
}
