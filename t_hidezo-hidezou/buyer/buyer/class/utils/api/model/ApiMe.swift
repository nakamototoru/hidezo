//
//  ApiMe.swift
//  seller
//
//  Created by NakaharaShun on 6/22/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import Foundation
import Unbox
import Wrap

struct Me: WrapCustomizable {
    
    let id: String
    let uuid: String
}

struct MeError: Unboxable {
    
    let message: String
    let result: Bool
    
    init(unboxer: Unboxer) throws {
		self.message = try! unboxer.unbox(key: "message")
		self.result = try! unboxer.unbox(key: "result")
    }
}

struct MeResult: Unboxable {
    
//    let message: String
    let result: Bool
    
    let address: String
    let mail_address: String
    let minister: String
    let mobile: String
    let name: String
    let tel: String
    
    init(unboxer: Unboxer) throws {
//        self.message = unboxer.unbox("message")
		self.result = try! unboxer.unbox(key: "result")

        self.address = try! unboxer.unbox(keyPath: "me.address")
        self.mail_address = try! unboxer.unbox(keyPath: "me.mail_address")
        self.minister = try! unboxer.unbox(keyPath: "me.minister")
        self.mobile = try! unboxer.unbox(keyPath: "me.mobile")
        self.name = try! unboxer.unbox(keyPath: "me.name")
        self.tel = try! unboxer.unbox(keyPath: "me.tel")
		
    }
}
