//
//  ApiFriend.swift
//  seller
//
//  Created by NakaharaShun on 6/20/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import Foundation
import Unbox
import Wrap

struct Friend: WrapCustomizable {
    let id: String
    let uuid: String
}

struct FriendError: Unboxable {
    
    let message: String
    let result: Bool
    
    init(unboxer: Unboxer) throws {
        self.message = try! unboxer.unbox(key: "message") //.unbox("message")
		self.result = try! unboxer.unbox(key: "result")
    }
}

struct FriendResult: Unboxable {
    
    let friendList: [FriendInfo]
//    let message: String
    let result: Bool
    
    init(unboxer: Unboxer) throws {
		self.friendList = try! unboxer.unbox(key: "friendList")
//        self.message = unboxer.unbox("message")
		self.result = try! unboxer.unbox(key: "result")
    }
}

struct FriendInfo: Unboxable {
    
    let address: String
    let id: String
    let mail_addr: String
    let minister: String
    let mobile: String
    let name: String
    let tel: String
    
    init(unboxer: Unboxer) throws {
		self.address = try! unboxer.unbox(key: "address")
        self.id = try! unboxer.unbox(key: "id")
        self.mail_addr = try! unboxer.unbox(key: "mail_addr")
        self.minister = try! unboxer.unbox(key: "minister")
        self.mobile = try! unboxer.unbox(key: "mobile")
        self.name = try! unboxer.unbox(key: "name")
        self.tel = try! unboxer.unbox(key: "tel")
    }
}
