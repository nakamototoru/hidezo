//
//  HDZImage.swift
//  buyer
//
//  Created by Shun Nakahara on 7/31/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit
import RealmSwift

class HDZImage: Object {
    
    dynamic var url: String = ""
    dynamic var data: Data?
    dynamic var createDate: Date = Date()
    dynamic var updateDate: Date = Date()
    
    dynamic var image: UIImage? {
        get {
            guard let value = self.data else {
                return nil
            }
//            return UIImage(data: value)
			
			return UIImage(data: value)
        }
        set {
            guard let value: UIImage = newValue else {
                self.data = nil
                return
            }
            //self.data = UIImageJPEGRepresentation(value, 1.0)
			self.data = UIImageJPEGRepresentation(value, 1.0)
        }
    }
    
    override static func primaryKey() -> String? {
        return "url"
    }
    
    override static func indexedProperties() -> [String] {
        return ["url"]
    }
    
    override static func ignoredProperties() -> [String] {
        return ["image"]
    }
}

extension HDZImage {
    
    internal class func add(url: String, data: Data) throws {
        
        let image: HDZImage = HDZImage()
        image.url = url
        image.data = data
        image.updateDate = Date()
        
        let realm: Realm = try Realm()
        
        let block: () throws -> Void = { 
            realm.add(image, update: true)
        }
        
        try realm.write(block)
    }
    
    internal class func queries(url: String) throws -> HDZImage?{
        let predicate = NSPredicate(format: "url = %@", url)
        let result: Results<HDZImage> = try Realm().objects(HDZImage.self).filter(predicate)
        
        guard let image: HDZImage = result.first else {
            return nil
        }

        return image
    }
}
