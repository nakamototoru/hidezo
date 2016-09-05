//
//  HDZOrder.swift
//  buyer
//
//  Created by Shun Nakahara on 7/31/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import Foundation
import RealmSwift

class HDZOrder: Object {
    
    dynamic var id: String = ""
    dynamic var supplierId: String = ""
    dynamic var itemId: String = ""
    dynamic var size: String = "0" //Int = 0
    dynamic var name: String = ""
    dynamic var price: String = ""
    dynamic var scale: String = ""
    dynamic var standard: String = ""
    dynamic var dynamic: Bool = false
    dynamic var imageURL: String = ""

	// !!!: dezami
	dynamic var numScaleStr: String = ""
	// !!!:dezami
	dynamic var createdAt: NSTimeInterval = 0.0
	
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["supplierId", "itemId"]
    }
}

extension HDZOrder {
    
	internal class func add(supplierId: String, itemId: String, size: String, name: String, price: String, scale: String, standard: String, imageURL: String?, dynamic: Bool, numScale: [String]) throws {
        
        var order: HDZOrder! = nil
        do {
            order = try HDZOrder.queries(supplierId, itemId: itemId, dynamic: dynamic)
        } catch let error as NSError {
			#if DEBUG
            debugPrint(error)
			#endif
        }
        
        if order == nil {
            order = HDZOrder()
            order.id = NSUUID().UUIDString
            order.itemId = itemId
            order.supplierId = supplierId
            order.dynamic = dynamic
			
			// !!!:dezami
			// 1970から現在までの秒数
			order.createdAt = NSDate().timeIntervalSince1970
			
			// 分数対応
			//order.numScale = numScale
			var count:Int = 0
			for str:String in numScale {
				if count > 0 {
					order.numScaleStr += "|"
				}
				order.numScaleStr += str
				
				count += 1
			}
			//
        }
		
        let realm: Realm = try Realm()
        
        let block: () throws -> Void = { 
            order.name = name
            order.price = price
            order.scale = scale
            order.size = size
            order.standard = standard
            
            if imageURL != nil {
                order.imageURL = imageURL!
            }
            
            realm.add(order, update: true)
        }
        
        try realm.write(block)
    }
    
    internal class func queries(supplierId: String, itemId: String, dynamic: Bool) throws -> HDZOrder? {
//        let predicate = NSPredicate(format: "supplierId = %ld AND itemId = %ld AND dynamic = %d", supplierId, itemId, dynamic.hashValue)
		
		let hash:String = String( dynamic.hashValue )
		let str:String = "supplierId = '" + supplierId + "' AND itemId = '" + itemId + "' AND dynamic = " + hash
		let predicate = NSPredicate(format: str)
		// !!!:ソート追加
        return try Realm().objects(HDZOrder.self).filter(predicate).sorted("createdAt").first
    }

    internal class func queries(supplierId: String) throws -> Results<HDZOrder> {
//        let predicate = NSPredicate(format: "supplierId = %ld", supplierId)

		let str:String = "supplierId = '" + supplierId + "'"
		let predicate = NSPredicate(format: str)
		// !!!:ソート追加
        return try Realm().objects(HDZOrder.self).filter(predicate).sorted("createdAt")
    }

    internal class func deleteObject(object: HDZOrder) throws {
            let realm: Realm = try Realm()
            try realm.write({
                realm.delete(object)
            })
    }

    internal class func deleteItem(supplierId: String, itemId: String, dynamic: Bool) throws {
        if let result: HDZOrder = try self.queries(supplierId, itemId: itemId, dynamic: dynamic) {
            let realm: Realm = try Realm()
            try realm.write({
                realm.delete(result)
            })
        }
    }
    
    internal class func deleteSupplier(supplierId: String) throws {
        let result: Results<HDZOrder> = try self.queries(supplierId)
        try Realm().delete(result)
    }
	
	// !!!: dezami
	internal class func updateSize(supplierId: String, itemId: String, dynamic: Bool, newsize: String) throws {

		if let result: HDZOrder = try self.queries(supplierId, itemId: itemId, dynamic: dynamic) {
			let realm: Realm = try Realm()
			try realm.write({
				//realm.delete(result)
				result.size = newsize
			})
		}

	}
}