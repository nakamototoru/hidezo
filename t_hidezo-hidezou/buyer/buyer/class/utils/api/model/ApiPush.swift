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

internal struct CustomDataSupplierUpResult: Unboxable {
	
	let supplierUpList: [SupplierId]?

	init(unboxer: Unboxer) {
		
		DeployGateExtra.DGSLog("CustomDataSupplierUpResult: Unboxable")

		self.supplierUpList = unboxer.unbox("supplierUpList", isKeyPath: false, context: nil, allowInvalidElements: true)
		
		DeployGateExtra.DGSLog("supplierUpList = pass")
	}
}

internal struct CustomDataMessageUpResult: Unboxable {
	
	let messageUpList: [MessageUp]?
	
	init(unboxer: Unboxer) {
		
		DeployGateExtra.DGSLog("CustomDataMessageUpResult: Unboxable")

		self.messageUpList = unboxer.unbox("messageUpList", isKeyPath: false, context: nil, allowInvalidElements: true)
		
		DeployGateExtra.DGSLog("messageUpList = pass")
	}
}

internal struct CustomDataResult: Unboxable {
	
	let supplierUp: CustomDataSupplierUpResult
	let messageUp: CustomDataMessageUpResult
	
	init(unboxer: Unboxer) {
		
		DeployGateExtra.DGSLog("CustomDataResult: Unboxable")

		self.supplierUp = unboxer.unbox("supplierUp")
		
		DeployGateExtra.DGSLog("supplierUp = pass")

		self.messageUp = unboxer.unbox("messageUp")
		
		DeployGateExtra.DGSLog("messageUp = pass")
	}
}

internal struct PushCustomDataResult: Unboxable {
	
	let custom_data:CustomDataResult
	
	init(unboxer:Unboxer) {
		
		DeployGateExtra.DGSLog("PushCustomDataResult: Unboxable")

		self.custom_data = unboxer.unbox("custom_data") // , isKeyPath: false, context: nil, allowInvalidElements: true
		
		DeployGateExtra.DGSLog("custom_data = pass")
	}
}

internal struct PushApsResult: Unboxable {

	let alert:String
	
	init(unboxer:Unboxer) {
		self.alert = unboxer.unbox("alert")
	}
}
