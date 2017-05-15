//
//  ApiMessage.swift
//  seller
//
//  Created by NakaharaShun on 6/24/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import Foundation
import Unbox
import Wrap

struct Message: WrapCustomizable {
    
    let id: String
    let uuid: String
    let order_no: String
}

struct MessageError: Unboxable {
    
    let message: String
    let result: Bool
    
    init(unboxer: Unboxer) throws {
		self.message = try! unboxer.unbox(key: "message")
        self.result = try! unboxer.unbox(key: "result")
    }
}

struct MessageResult: Unboxable {
    
//    let message: String
    let messageCount: Int
    let result: Bool
    let chargeList: [String]
    let messageList: [MessageInfo]
    
    init(unboxer: Unboxer) throws {
//        self.message = unboxer.unbox("message")
        self.messageCount = try! unboxer.unbox(key: "messageCount")
        self.result = try! unboxer.unbox(key: "result")
        self.chargeList = try! unboxer.unbox(key: "chargeList")
        self.messageList = try! unboxer.unbox(key: "messageList")
    }
}

struct MessageInfo: Unboxable {
    
    let charge: String
    let message: String
    let name: String
    let posted_at: String
    let user_flg: String
    
    init(unboxer: Unboxer) throws {
        self.charge = try! unboxer.unbox(key: "charge")
        self.message = try! unboxer.unbox(key: "message")
        self.name = try! unboxer.unbox(key: "name")
        self.posted_at = try! unboxer.unbox(key: "posted_at")
        self.user_flg = try! unboxer.unbox(key: "user_flg")
    }
}

struct MessageAdd: WrapCustomizable {

    let id: String
    let uuid: String
    let charge: String
    let message: String
    let order_no: String
}

struct MessageAddError: Unboxable {

    let message: String
    let result: Bool
    
    init(unboxer: Unboxer) throws {
        self.message = try! unboxer.unbox(key: "message")
        self.result = try! unboxer.unbox(key: "result")
    }
}

struct MessageAddResult: Unboxable {

//    let message: String
    let result: Bool
    
    init(unboxer: Unboxer) throws {
//        self.message = unboxer.unbox("message")
        self.result = try! unboxer.unbox(key: "result")
    }
}
