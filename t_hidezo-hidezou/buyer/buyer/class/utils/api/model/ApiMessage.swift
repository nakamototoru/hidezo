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
    
    init(unboxer: Unboxer) {
        self.message = unboxer.unbox("message")
        self.result = unboxer.unbox("result")
    }
}

struct MessageResult: Unboxable {
    
//    let message: String
    let messageCount: Int
    let result: Bool
    let chargeList: [String]
    let messageList: [MessageInfo]
    
    init(unboxer: Unboxer) {
//        self.message = unboxer.unbox("message")
        self.messageCount = unboxer.unbox("messageCount")
        self.result = unboxer.unbox("result")
        self.chargeList = unboxer.unbox("chargeList")
        self.messageList = unboxer.unbox("messageList")
    }
}

struct MessageInfo: Unboxable {
    
    let charge: String
    let message: String
    let name: String
    let posted_at: String
    let user_flg: String
    
    init(unboxer: Unboxer) {
        self.charge = unboxer.unbox("charge")
        self.message = unboxer.unbox("message")
        self.name = unboxer.unbox("name")
        self.posted_at = unboxer.unbox("posted_at")
        self.user_flg = unboxer.unbox("user_flg")
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
    
    init(unboxer: Unboxer) {
        self.message = unboxer.unbox("message")
        self.result = unboxer.unbox("result")
    }
}

struct MessageAddResult: Unboxable {

//    let message: String
    let result: Bool
    
    init(unboxer: Unboxer) {
//        self.message = unboxer.unbox("message")
        self.result = unboxer.unbox("result")
    }
}
