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
    
    init(unboxer: Unboxer) throws {
        self.message = try! unboxer.unbox(key: "message")
        self.result = try! unboxer.unbox(key: "result")
    }
}

struct OrderListResult: Unboxable {
    
//    let message: String
    let orderList: [OrderInfo]
    let result: Bool

    init(unboxer: Unboxer) throws {
//        self.message = unboxer.unbox("message")
        self.orderList = try! unboxer.unbox(key: "order_list")
        self.result = try! unboxer.unbox(key: "result")
    }
}

struct OrderInfo: Unboxable {

    let deliver_at: String? // = "01/01"
    let order_at: String // = "06/12"
    let order_no: String
    let supplier: String
    let supplier_name: String
    
    init(unboxer: Unboxer) throws {
        self.deliver_at = unboxer.unbox(key: "deliver_at")
        self.order_at = try! unboxer.unbox(key: "order_at")
        self.order_no = try! unboxer.unbox(key: "order_no")
        self.supplier = try! unboxer.unbox(key: "supplier")
        self.supplier_name = try! unboxer.unbox(key: "supplier_name")
    }
	
//	init(unboxer: Unboxer) throws {
//		self.deliver_at = unboxer.unbox(key: "deliver_at")
//		self.order_at = try! unboxer.unbox(key: "order_at")
//		self.order_no = try! unboxer.unbox(key: "order_no")
//		self.supplier = try! unboxer.unbox(key: "supplier")
//		self.supplier_name = try! unboxer.unbox(key: "supplier_name")
//	}
}

struct OrderDetail: WrapCustomizable {
    
    let id: String
    let uuid: String
    let order_no: String
}

struct OrderDetailError: Unboxable {
    
    let message: String
    let result: Bool
    
    init(unboxer: Unboxer) throws {
		self.message = try! unboxer.unbox(key: "message")
        self.result = try! unboxer.unbox(key: "result")
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
    let delivery_day: String?
    let order_no: String

    init(unboxer: Unboxer) throws {
		self.attr_flg = try! unboxer.unbox(key: "attr_flg")
        self.deliveryFee = try! unboxer.unbox(key: "deliveryFee")
        self.subtotal = try! unboxer.unbox(key: "subtotal")
        self.total = try! unboxer.unbox(key: "total")
        self.message = try! unboxer.unbox(key: "message")
        self.result = try! unboxer.unbox(key: "result")
        self.dynamicItemList = try! unboxer.unbox(key: "dynamicItemList")
        self.staicItemList = try! unboxer.unbox(key: "staicItemList")

		self.order_no = try! unboxer.unbox(keyPath: "order.order_no")
        self.charge = try! unboxer.unbox(keyPath: "order.charge")
        self.deliver_to = try! unboxer.unbox(keyPath: "order.deliver_to")
        self.delivery_day = unboxer.unbox(keyPath: "order.delivery_day")
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
    
    init(unboxer: Unboxer) throws {
		self.code = try! unboxer.unbox(key: "code")
        self.id = try! unboxer.unbox(key: "id")
        self.name = try! unboxer.unbox(key: "name")
        self.num_scale = unboxer.unbox(key: "num_scale")
        self.order_num = try! unboxer.unbox(key: "order_num")
        self.price = try! unboxer.unbox(key: "price")
        self.loading = unboxer.unbox(key: "loading")
        self.scale = unboxer.unbox(key: "scale")
        self.standard = unboxer.unbox(key: "standard")
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
    
    init(unboxer: Unboxer) throws {
//        self.message = unboxer.unbox("message")
		self.order_no = try! unboxer.unbox(key: "order_no")
    }
}

struct OrderError: Unboxable {
    
	let message: String
    init(unboxer: Unboxer) throws {
		self.message = try! unboxer.unbox(key: "message")
    }
}

// MARK: FAX用
struct FaxError:Unboxable {
	let message: String
	let result: Bool
	
	init(unboxer: Unboxer) throws {
		self.message = try! unboxer.unbox(key: "message")
		self.result = try! unboxer.unbox(key: "result")
	}
}
struct FaxResult:Unboxable {
	let result: Bool
//	let message: String
	init(unboxer: Unboxer) throws {
		self.result = try! unboxer.unbox(key: "result")
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
	
	init(unboxer: Unboxer) throws {
		self.result = try! unboxer.unbox(key: "result")
//		self.message = unboxer.unbox("message")
		
		self.method = try! unboxer.unbox(key: "method")
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
	init(unboxer:Unboxer) throws {
		self.id = try! unboxer.unbox(key: "id")
		self.name = try! unboxer.unbox(key: "name")
		self.size = try! unboxer.unbox(key: "size")
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
	
	init(unboxer: Unboxer) throws {
		self.store_name = try! unboxer.unbox(key: "store_name")
		self.store_code = try! unboxer.unbox(key: "store_code")
		self.store_address = try! unboxer.unbox(key: "store_address")
		self.order_at = try! unboxer.unbox(key: "order_at")
		self.deliver_at = try! unboxer.unbox(key: "deliver_at")
		self.faxdocitems = try! unboxer.unbox(key: "item_list")
		self.comment = try! unboxer.unbox(key: "comment")
		self.supplier_name = try! unboxer.unbox(key: "supplier_name")
		self.fax = try! unboxer.unbox(key: "fax")
	}
	
}

struct FaxDocResult:Unboxable {
	
	let result: Int
	let faxdoc:FaxDocInfo

	init(unboxer: Unboxer) throws {
		self.result = try! unboxer.unbox(key: "result")
		self.faxdoc = try! unboxer.unbox(key: "faxdoc")
	}
}
