//
//  ApiItem.swift
//  buyer
//
//  Created by NakaharaShun on 10/07/2016.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import Foundation
import Unbox
import Wrap

struct Item: WrapCustomizable {
    let id: String
    let uuid: String
    let supplier_id: String
}

struct ItemResult: Unboxable {
    
    let attr_flg: AttrFlg
//    let badge_total: Int
    let message: String
    let result: Int
    let charge_list: [String]
    let deliver_to_list: [String]
    let supplier: Supplier
	let staticItem: [StaticItem]?
    let dynamicItem: [DynamicItem]?
	let dynamicItemInfo: [DynamicItemInfo]?
	
    init(unboxer: Unboxer) {
		self.result = unboxer.unbox("result")
		self.message = unboxer.unbox("message")
		self.supplier = unboxer.unbox("supplier")
		self.deliver_to_list = unboxer.unbox("deliver_to_list")
		self.charge_list = unboxer.unbox("charge_list")
		self.attr_flg = unboxer.unbox("attr_flg")
//        self.badge_total = unboxer.unbox("badge_total")
		self.dynamicItem = unboxer.unbox("dynamicItem", isKeyPath: false, context: nil, allowInvalidElements: true) //
		self.dynamicItemInfo = unboxer.unbox("dynamicItemInfo", isKeyPath: false, context: nil, allowInvalidElements: true) //
		self.staticItem = unboxer.unbox("staticItem" , isKeyPath: false, context: nil, allowInvalidElements: true) //
    }
}

struct StaticItem: Unboxable {
    
    let category: Category
    let code: String
    let detail: String
    let id: String
    let image: NSURL
    let loading: Int
    let min_order_count: String
    let name: String
    let standard: String
    let price: String
    let scale: String
    let num_scale: [String]
    
    init(unboxer: Unboxer) {
        self.category = unboxer.unbox("category")
        self.code = unboxer.unbox("code")
        self.detail = unboxer.unbox("detail")
        self.id = unboxer.unbox("id")
        self.loading = unboxer.unbox("loading")
        self.min_order_count = unboxer.unbox("min_order_count")
        self.name = unboxer.unbox("name")
        self.standard = unboxer.unbox("standard")
        self.price = unboxer.unbox("price")
        self.scale = unboxer.unbox("scale")
        self.num_scale = unboxer.unbox("num_scale")
		self.image = unboxer.unbox("image")
    }
}

struct OrderdItemResult:Unboxable {
    
    let message: String
    let result: Int
    let orderdStaticItems: [OrderdStaticItem]?
    
    init(unboxer: Unboxer) {
        self.result = unboxer.unbox("result")
        self.message = unboxer.unbox("message")
        self.orderdStaticItems = unboxer.unbox("ordredStaticItem" , isKeyPath: false, context: nil, allowInvalidElements: true)
		
//		debugPrint(self.orderdStaticItems)
    }
}
struct OrderdStaticItem: Unboxable {
    let category: Category
    let code: String
    let detail: String
    let id: String
    let loading: Int
    let min_order_count: String
    let name: String
    let standard: String
    let price: String
    let scale: String
    let num_scale: [String]
    
    init(unboxer: Unboxer) {
        self.category = unboxer.unbox("category")
        self.code = unboxer.unbox("code")
        self.detail = unboxer.unbox("detail")
        self.id = unboxer.unbox("id")
        self.loading = unboxer.unbox("loading")
        self.min_order_count = unboxer.unbox("min_order_count")
        self.name = unboxer.unbox("name")
        self.standard = unboxer.unbox("standard")
        self.price = unboxer.unbox("price")
        self.scale = unboxer.unbox("scale")
        self.num_scale = unboxer.unbox("num_scale")
    }
}

struct DisplayStaticItem {
	internal var code: String = ""
	internal var detail: String = ""
	internal var id: String = ""
	internal var loading: Int = 0
	internal var min_order_count: String = ""
	internal var name: String = ""
	internal var num_scale: [String] = []
	internal var price: String = ""
	internal var scale: String = ""
	internal var standard: String = ""
}

struct DynamicItemInfo: Unboxable {
    
    let imagePath: [String]
    let text: String
    let lastUpdate: NSDate
    
    init(unboxer: Unboxer) {
        self.imagePath = unboxer.unbox("imagePath")
        self.text = unboxer.unbox("text")
        self.lastUpdate = unboxer.unbox("lastUpdate", formatter: NSDateFormatter(type: .DateTime))
    }
}

struct Supplier: Unboxable {
    
    let supplier_id: String
    let supplier_name: String
    
    init(unboxer: Unboxer) {
        self.supplier_id = unboxer.unbox("supplier_id")
        self.supplier_name = unboxer.unbox("supplier_name")
    }
}

struct DynamicItem: Unboxable {
    
    let id: String
    let item_name: String
    let num_scale: [String]
    let price: String
    
    init(unboxer: Unboxer) {
        self.id = unboxer.unbox("id")
        self.item_name = unboxer.unbox("item_name")
        self.num_scale = unboxer.unbox("num_scale")
        self.price = unboxer.unbox("price")
    }
}

struct Category: Unboxable {
    
    let id: String
    let name: String
    let image_flg:Int
    
    init(unboxer: Unboxer) {
        self.id = unboxer.unbox("id")
        self.name = unboxer.unbox("name")
        
        self.image_flg = unboxer.unbox("image_flg")
    }
}

struct ItemError: Unboxable {

    let message: String
    let result: Bool
    
    init(unboxer: Unboxer) {
        self.message = unboxer.unbox("message")
        self.result = unboxer.unbox("result")
    }
}
