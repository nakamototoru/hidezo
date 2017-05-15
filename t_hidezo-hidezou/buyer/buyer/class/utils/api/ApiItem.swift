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
	let staticItems: [StaticItem]?
    let dynamicItems: [DynamicItem]?
	let dynamicItemInfo: [DynamicItemInfo]?
	let delivery_day_list:[String]
	
    init(unboxer: Unboxer) throws {
		
		self.result = try! unboxer.unbox(key: "result")
		self.message = try! unboxer.unbox(key: "message")
		self.supplier = try! unboxer.unbox(key: "supplier")
		self.deliver_to_list = try! unboxer.unbox(key: "deliver_to_list")
		self.charge_list = try! unboxer.unbox(key: "charge_list")
		self.attr_flg = try! unboxer.unbox(key: "attr_flg")
		//        self.badge_total = unboxer.unbox("badge_total")
		self.dynamicItems = unboxer.unbox(key: "dynamicItem", allowInvalidElements: true) //
		self.dynamicItemInfo = unboxer.unbox(key: "dynamicItemInfo", allowInvalidElements: true) //
		self.staticItems = unboxer.unbox(key: "staticItem", allowInvalidElements: true) //
		self.delivery_day_list = try! unboxer.unbox(key: "delivery_day_list")
    }
}

struct StaticItem: Unboxable {
    
    let category: Category
    let code: String
    let detail: String
    let id: String
    let image: URL
    let loading: String // Int
    let min_order_count: String
    let name: String
    let standard: String
    let price: String
    let scale: String
    let num_scale: [String]
    
    init(unboxer: Unboxer) throws {
		
//		debugPrint("StaticItem:BEGIN")

        self.category = try! unboxer.unbox(key: "category")
        self.code = try! unboxer.unbox(key: "code")
        self.detail = try! unboxer.unbox(key: "detail")
        self.id = try! unboxer.unbox(key: "id")
        self.loading = try! unboxer.unbox(key: "loading")
        self.min_order_count = try! unboxer.unbox(key: "min_order_count")
        self.name = try! unboxer.unbox(key: "name")
        self.standard = try! unboxer.unbox(key: "standard")
        self.price = try! unboxer.unbox(key: "price")
        self.scale = try! unboxer.unbox(key: "scale")
        self.num_scale = try! unboxer.unbox(key: "num_scale")
		self.image = try! unboxer.unbox(key: "image")
		
//		debugPrint("StaticItem:END")
    }
}

struct OrderdItemResult:Unboxable {
    
	//    let message: String
    let result: Int
    let orderdStaticItems: [OrderdStaticItem]?
    
    init(unboxer: Unboxer) throws {
        self.result = try! unboxer.unbox(key: "result")
		//        self.message = unboxer.unbox("message")
        self.orderdStaticItems = unboxer.unbox(key: "ordredStaticItem", allowInvalidElements: true)
		
//		debugPrint(self.orderdStaticItems)
    }
}
struct OrderdStaticItem: Unboxable {
    let category: Category
    let code: String
    let detail: String
    let id: String
    let loading: String // Int
    let min_order_count: String
    let name: String
    let standard: String
    let price: String
    let scale: String
    let num_scale: [String]
    
    init(unboxer: Unboxer) throws {
        self.category = try! unboxer.unbox(key: "category")
        self.code = try! unboxer.unbox(key: "code")
        self.detail = try! unboxer.unbox(key: "detail")
        self.id = try! unboxer.unbox(key: "id")
        self.loading = try! unboxer.unbox(key: "loading")
        self.min_order_count = try! unboxer.unbox(key: "min_order_count")
        self.name = try! unboxer.unbox(key: "name")
        self.standard = try! unboxer.unbox(key: "standard")
        self.price = try! unboxer.unbox(key: "price")
		self.scale = try! unboxer.unbox(key: "scale")
        self.num_scale = try! unboxer.unbox(key: "num_scale")
    }
}

struct DisplayStaticItem {
	internal var code: String = ""
	internal var detail: String = ""
	internal var id: String = ""
	internal var loading: String = "" // Int = 0
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
    let lastUpdate: Date
    
    init(unboxer: Unboxer) throws {
        self.imagePath = try! unboxer.unbox(key: "imagePath")
        self.text = try! unboxer.unbox(key: "text")
        self.lastUpdate = try! unboxer.unbox(key: "lastUpdate", formatter: DateFormatter(type: .DateTime))
    }
}

struct Supplier: Unboxable {
    
    let supplier_id: String
    let supplier_name: String
    
    init(unboxer: Unboxer) throws {
        self.supplier_id = try! unboxer.unbox(key: "supplier_id")
        self.supplier_name = try! unboxer.unbox(key: "supplier_name")
    }
}

struct DynamicItem: Unboxable {
    
    let id: String
    let item_name: String
    let num_scale: [String]
    let price: String
    
    init(unboxer: Unboxer) throws {
        self.id = try! unboxer.unbox(key: "id")
        self.item_name = try! unboxer.unbox(key: "item_name")
        self.num_scale = try! unboxer.unbox(key: "num_scale")
        self.price = try! unboxer.unbox(key: "price")
    }
}

struct Category: Unboxable {
    
    let id: String
    let name: String
    let image_flg:Int
    
    init(unboxer: Unboxer) throws {
        self.id = try! unboxer.unbox(key: "id")
        self.name = try! unboxer.unbox(key: "name")
        self.image_flg = try! unboxer.unbox(key: "image_flg")
    }
}

struct ItemError: Unboxable {

    let message: String
    let result: Bool
    
    init(unboxer: Unboxer) throws {
		self.message = try! unboxer.unbox(key: "message")
        self.result = try! unboxer.unbox(key: "result")
    }
}
