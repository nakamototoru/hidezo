//
//  ApiPush.swift
//  buyer
//
//  Created by デザミ on 2016/08/26.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import Foundation
import Unbox
import Wrap

// MARK: - DeviceToken
// MARK: Request
internal struct DeviceToken: WrapCustomizable {
	
	let id: String
	let uuid: String
	let device_token: String
	let device_flg: String
}

// MARK: Response
internal struct DeviceTokenResult: Unboxable {
	
	let message: String
	let result: Bool
	
	init(unboxer: Unboxer) {
		self.message = unboxer.unbox("message")
		self.result = unboxer.unbox("result")
	}
}

// MARK: - CustomData

internal struct SupplierId:Unboxable {
	
	let supplierId: String
	
	init(unboxer: Unboxer) {
		self.supplierId = unboxer.unbox("supplierId")
	}
}

internal struct MessageUp:Unboxable {
	
	let order_no:String
	let messageCount:String
	
	init(unboxer: Unboxer) {
		self.order_no = unboxer.unbox("order_no")
		self.messageCount = unboxer.unbox("messageCount")
	}
}

internal struct SupplierUpListResult: Unboxable {
	
	let supplierUpList: [SupplierId]
	
	init(unboxer: Unboxer) {
		self.supplierUpList = unboxer.unbox("supplierUpList")
	}
}

internal struct MessageUpListResult: Unboxable {
	
	let messageUpList: [MessageUp]
	
	init(unboxer: Unboxer) {
		self.messageUpList = unboxer.unbox("messageUpList")
	}
}

//internal struct NotificationDataResult:Unboxable {
//	
//	let supplierList: [SupplierId]
//	let messageUpList: [MessageUp]
//
//	init(unboxer: Unboxer) {
//		self.supplierList = unboxer.unbox("supplierList")
//		self.messageUpList = unboxer.unbox("messageUpList")
//	}
//}
