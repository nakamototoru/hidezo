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
		
		DeployGateExtra.DGSLog("SupplierId:Unboxable")

		self.supplierId = unboxer.unbox("supplierId")
		
		DeployGateExtra.DGSLog("supplierId = pass")
	}
}

internal struct MessageUp:Unboxable {
	
	let order_no:String
	let messageCount:Int
	
	init(unboxer: Unboxer) {
		
		DeployGateExtra.DGSLog("MessageUp:Unboxable")
		
		self.order_no = unboxer.unbox("order_no")
		
		DeployGateExtra.DGSLog("order_no = pass")
		
		self.messageCount = unboxer.unbox("messageCount")
		
		DeployGateExtra.DGSLog("messageCount = pass")
	}
}

internal struct SupplierUpResult: Unboxable {
	
	let supplierUpList: [SupplierId]?

	init(unboxer: Unboxer) {
		
		DeployGateExtra.DGSLog("SupplierUpListResult: Unboxable")

		self.supplierUpList = unboxer.unbox("supplierUpList", isKeyPath: false, context: nil, allowInvalidElements: true)
		
		DeployGateExtra.DGSLog("supplierUpList = pass")
	}
}

internal struct MessageUpResult: Unboxable {
	
	let messageUpList: [MessageUp]?
	
	init(unboxer: Unboxer) {
		
		DeployGateExtra.DGSLog("MessageUpListResult: Unboxable")

		self.messageUpList = unboxer.unbox("messageUpList", isKeyPath: false, context: nil, allowInvalidElements: true)
		
		DeployGateExtra.DGSLog("messageUpList = pass")
	}
}

struct BadgeResult: Unboxable {
	
	let message: String
	let result: Int
	let supplierUp: SupplierUpResult
	let messageUp: MessageUpResult

	init(unboxer: Unboxer) {
		self.result = unboxer.unbox("result")
		self.message = unboxer.unbox("message")

		self.supplierUp = unboxer.unbox("supplierUp");
		self.messageUp = unboxer.unbox("messageUp");
	}
}

struct BadgeError: Unboxable {
	
	let message: String
	let result: Bool
	
	init(unboxer: Unboxer) {
		self.message = unboxer.unbox("message")
		self.result = unboxer.unbox("result")
	}
}

// リクエスト用
struct ParamsBadge: WrapCustomizable {
	let id: String
	let uuid: String
}

// PUSH通知のパラメータ取得
internal struct PushApsResult: Unboxable {

	let alert:String
	
	init(unboxer:Unboxer) {
		self.alert = unboxer.unbox("alert")
	}
}
