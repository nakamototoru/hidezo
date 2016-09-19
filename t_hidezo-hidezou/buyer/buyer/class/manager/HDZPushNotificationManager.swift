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
