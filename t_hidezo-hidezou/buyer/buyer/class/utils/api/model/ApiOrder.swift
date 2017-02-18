//
//  ApiOrder.swift
//  seller
//
//  Created by NakaharaShun on 6/21/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import Foundation
import Unbox
import Wrap

struct OrderList: WrapCustomizable {
    
    let id: String
    let uuid: String
    let page: Int
}

struct OrderListError: Unboxable {
    
    let message: String
    let result: Bool
    
    init(unboxer: Unboxer) {
        self.message = unboxer.unbox("message")
        self.result = unboxer.unbox("result")
    }
}

struct OrderListResult: Unboxable {
    
//    let message: String
    let orderList: [OrderInfo]
    let result: Bool

    init(unboxer: Unboxer) {
//        self.message = unboxer.unbox("message")
        self.orderList = unboxer.unbox("order_list")
        self.result = unboxer.unbox("result")
    }
}

struct OrderInfo: Unboxable {

    let deliver_at: String // = "01/01"
    let order_at: String // = "06/12"
    let order_no: String
    let supplier: String
    let supplier_name: String
    
    init(unboxer: Unboxer) {
        self.deliver_at = unboxer.unbox("deliver_at")
        self.order_at = unboxer.unbox("order_at")
        self.order_no = unboxer.unbox("order_no")
        self.supplier = unboxer.unbox("supplier")
        self.supplier_name = unboxer.unbox("supplier_name")
    }
}

struct OrderDetail: WrapCustomizable {
    
    let id: String
    let uuid: String
    let order_no: String
}

struct OrderDetailError: Unboxable {
    
    let message: String
    let result: Bool
    
    init(unboxer: Unboxer) {
        self.message = unboxer.unbox("message")
        self.result = unboxer.unbox("result")
    }
}

struct OrderDetailResult: Unboxable {
    
    let attr_flg: AttrFlg
    let deliveryFee: Int
    let subtotal: Int
    let total: Int

    let message: String
    let result: Bool

    let dynamicItemList: [OrderDetailItem]
    let staicItemList: [OrderDetailItem]
    
    let charge: String
    let deliver_to: String
    let delivery_day: String
    let order_no: String

    init(unboxer: Unboxer) {
        self.attr_flg = unboxer.unbox("attr_flg")
        self.deliveryFee = unboxer.unbox("deliveryFee")
        self.subtotal = unboxer.unbox("subtotal")
        self.total = unboxer.unbox("total")
        self.message = unboxer.unbox("message")
        self.result = unboxer.unbox("result")
        self.dynamicItemList = unboxer.unbox("dynamicItemList")
        self.staicItemList = unboxer.unbox("staicItemList")

        self.order_no = unboxer.unbox("order.order_no", isKeyPath: true)
        self.charge = unboxer.unbox("order.charge", isKeyPath: true)
        self.deliver_to = unboxer.unbox("order.deliver_to", isKeyPath: true)
        self.delivery_day = unboxer.unbox("order.delivery_day", isKeyPath: true)
    }
}

enum AttrFlg: String, UnboxableEnum {
    
    case direct = "1"
    case group = "2"
    case other = "3"
    
    static func unboxFallbackValue() -> AttrFlg {
        return .other
    }
}

struct OrderDetailItem: Unboxable {
	
    // Dynamic
    let code: String
    let id: String
    let name: String
    let num_scale: [String]?
    let order_num: String
    let price: String
    
    // Staic
    let loading: String?
    let scale: String?
    let standard: String?
    
    init(unboxer: Unboxer) {
        self.code = unboxer.unbox("code")
        self.id = unboxer.unbox("id")
        self.name = unboxer.unbox("name")
        self.num_scale = unboxer.unbox("num_scale")
        self.order_num = unboxer.unbox("order_num")
        self.price = unboxer.unbox("price")
        self.loading = unboxer.unbox("loading")
        self.scale = unboxer.unbox("scale")
        self.standard = unboxer.unbox("standard")
    }
}

struct Order: WrapCustomizable {
    
//    id	飲食店ID	ログイン画面で入力される
//    uuid	UUID	アプリで生成
//    supplier_id	卸業者ID
//    static_item[]	静的商品IDと注文個数	ID,個数　カンマ区切り
//    dynamic_item[]	動的商品IDと注文個数	ID,個数　カンマ区切り
//    deliver_to	配送先
//    delivery_day	配送日
//    charge	注文担当者
    
    let id: String
    let uuid: String
    let supplier_id: String
    let static_item: [String] // ID,個数　カンマ区切り
    let dynamic_item: [String] // ID,個数　カンマ区切り
    let deliver_to: String
    let delivery_day: String
    let charge: String    
}

struct OrderResult: Unboxable {
    
//    let message: String
	let order_no: String
    
    init(unboxer: Unboxer) {
//        self.message = unboxer.unbox("message")
		self.order_no = unboxer.unbox("order_no")
    }
}

struct OrderError: Unboxable {
    
	let message: String
    init(unboxer: Unboxer) {
		self.message = unboxer.unbox("message")
    }
}

// MARK: FAX用
struct FaxError:Unboxable {
	let message: String
	let result: Bool
	
	init(unboxer: Unboxer) {
		self.message = unboxer.unbox("message")
		self.result = unboxer.unbox("result")
	}
}
struct FaxResult:Unboxable {
	let result: Bool
//	let message: String
	init(unboxer: Unboxer) {
		self.result = unboxer.unbox("result")
//		self.message = unboxer.unbox("message")
	}
}
struct FaxParam:WrapCustomizable {
	let id:String
	let uuid:String
}

// TODO: 以下は使わなくなる
struct OrderMethod:WrapCustomizable {
	
	let id: String
	let uuid: String
	let supplier_id: String
}

struct OrderMethodResult:Unboxable {
	
//	let message: String
	let result: Int
	let method:String
	
	init(unboxer: Unboxer) {
		self.result = unboxer.unbox("result")
//		self.message = unboxer.unbox("message")
		
		self.method = unboxer.unbox("method")
	}
}

struct FaxDoc:WrapCustomizable {
	
	let id: String
	let uuid: String
	let order_no:String
}

struct FaxDocItem:Unboxable {
	
	let id:String
	let name:String
	let size:String
	init(unboxer:Unboxer) {
		self.id = unboxer.unbox("id")
		self.name = unboxer.unbox("name")
		self.size = unboxer.unbox("size")
	}
}

struct FaxDocInfo:Unboxable {
	
	let store_name:String
	let store_code:String
	let store_address:String
	let order_at:String
	let deliver_at:String
	let faxdocitems:[FaxDocItem]
	let comment:String
	let supplier_name:String
	let fax:String
	
	init(unboxer: Unboxer) {
		self.store_name = unboxer.unbox("store_name")
		self.store_code = unboxer.unbox("store_code")
		self.store_address = unboxer.unbox("store_address")
		self.order_at = unboxer.unbox("order_at")
		self.deliver_at = unboxer.unbox("deliver_at")
		self.faxdocitems = unboxer.unbox("item_list")
		self.comment = unboxer.unbox("comment")
		self.supplier_name = unboxer.unbox("supplier_name")
		self.fax = unboxer.unbox("fax")
	}
	
}

struct FaxDocResult:Unboxable {
	
	let result: Int
	let faxdoc:FaxDocInfo

	init(unboxer: Unboxer) {
		self.result = unboxer.unbox("result")

		self.faxdoc = unboxer.unbox("faxdoc")
	}
}
