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
    
    let id: Int
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
    
    let message: String
    let orderList: [OrderInfo]
    let result: Bool

    init(unboxer: Unboxer) {
        self.message = unboxer.unbox("message")
        self.orderList = unboxer.unbox("orderList")
        self.result = unboxer.unbox("result")
    }
}

struct OrderInfo: Unboxable {

    let deliver_at: String // = "01/01"
    let order_at: String // = "06/12"
    let order_no: String
    let store_id: Int
    let store_name: String
    
    init(unboxer: Unboxer) {
        self.deliver_at = unboxer.unbox("deliver_at")
        self.order_at = unboxer.unbox("order_at")
        self.order_no = unboxer.unbox("order_no")
        self.store_id = unboxer.unbox("store_id")
        self.store_name = unboxer.unbox("store_name")
    }
}

struct OrderDetail: WrapCustomizable {
    
    let id: Int
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
    
    let order_no: String

    let attr_flg: AttrFlg
    
    let message: String
    let result: Bool

    let dynamicItemList: [OrderDetailItem]
    let staicItemList: [OrderDetailItem]
    
    let deliveryFee: Int
    let subtotal: Int
    let total: Int
    let charge: String
    let deliver_to: String
    let delivery_day: String
    let deliver_to_list: [String]

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
        self.deliver_to_list = unboxer.unbox("deliver_to_list")
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
    let id: Int
    let name: String
    let num_scale: [String]
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
    
    init(orderDetailItem: OrderDetailItem!,order_num: String) {
        self.code = orderDetailItem.code
        self.id = orderDetailItem.id
        self.name = orderDetailItem.name
        self.num_scale = orderDetailItem.num_scale
        self.scale = orderDetailItem.scale
        self.standard = orderDetailItem.standard
        self.loading = orderDetailItem.loading
        self.price = orderDetailItem.price
        self.order_num = order_num
    }
}

struct OrderUpdate: WrapCustomizable {
    let id: Int
    let uuid: String
    let order_no: String
    let items: [String] // 受注ID,個数
    let deliver_to: String
    let delivery_day: String
    let charge: String
}

struct OrderUpdateResult: Unboxable {
    
    init(unboxer: Unboxer) {
        
    }
}

struct OrderUpdateError: Unboxable {

    let message: String
    let result: Bool
    
    init(unboxer: Unboxer) {
        self.message = unboxer.unbox("message")
        self.result = unboxer.unbox("result")
    }
}


