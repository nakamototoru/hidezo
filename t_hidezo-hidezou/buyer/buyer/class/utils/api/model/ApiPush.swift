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

// MARK: - デバイストークン
// MARK: リクエスト
internal struct DeviceToken: WrapCustomizable {
	
	let id: String
	let uuid: String
	let device_token: String
	let device_flg: String
}

// MARK: レスポンス
internal struct DeviceTokenResult: Unboxable {
	
	//	let message: String
	let result: Bool
	
	init(unboxer: Unboxer) throws {
		//		self.message = unboxer.unbox("message")
		self.result = try! unboxer.unbox(key: "result")
	}
}

internal struct DeviceTokenError: Unboxable {
	
	let message: String
	let result: Bool
	
	init(unboxer: Unboxer) throws {
		self.message = try! unboxer.unbox(key: "message")
		self.result = try! unboxer.unbox(key: "result")
	}
}

// MARK: - 更新情報
internal struct SupplierId:Unboxable {
	
	let supplierId: String
	
	init(unboxer: Unboxer) throws {
		self.supplierId = try! unboxer.unbox(key: "supplierId")
	}
}

internal struct MessageUp:Unboxable {
	
	let order_no:String
	let messageCount:Int
	
	init(unboxer: Unboxer) throws {
		self.order_no = try! unboxer.unbox(key: "order_no")
		self.messageCount = try! unboxer.unbox(key: "messageCount")
	}
}

internal struct SupplierUpResult: Unboxable {
	
	let supplierUpList: [SupplierId]?

	init(unboxer: Unboxer) throws {
		//self.supplierUpList = try! unboxer.unbox(key: "supplierUpList", isKeyPath: false, context: nil, allowInvalidElements: true)
		self.supplierUpList = unboxer.unbox(key: "supplierUpList", allowInvalidElements: true)
	}
}

internal struct MessageUpResult: Unboxable {
	
	let messageUpList: [MessageUp]?
	
	init(unboxer: Unboxer) {
		//self.messageUpList = try! unboxer.unbox(key: "messageUpList", isKeyPath: false, context: nil, allowInvalidElements: true)
		self.messageUpList = unboxer.unbox(key: "messageUpList", allowInvalidElements: true)
	}
}

// MARK: - バッジ用
struct BadgeResult: Unboxable {
	
//	let message: String
	let result: Int
	let supplierUp: SupplierUpResult
	let messageUp: MessageUpResult

	init(unboxer: Unboxer) throws {
		self.result = try! unboxer.unbox(key: "result")
		//		self.message = unboxer.unbox("message")
		self.supplierUp = try! unboxer.unbox(key: "supplierUp");
		self.messageUp = try! unboxer.unbox(key: "messageUp");
	}
}

struct BadgeError: Unboxable {
	
	let message: String
	let result: Bool
	
	init(unboxer: Unboxer) throws {
		self.message = try! unboxer.unbox(key: "message")
		self.result = try! unboxer.unbox(key: "result")
	}
}

// MARK: - リクエスト用
struct ParamsBadge: WrapCustomizable {
	let id: String
	let uuid: String
}

// MARK: PUSH通知のパラメータ取得
internal struct PushApsResult: Unboxable {

	let alert:String
	
	init(unboxer:Unboxer) throws {
		self.alert = try! unboxer.unbox(key: "alert")
	}
}
