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
    
    init(unboxer: Unboxer) {
        self.message = unboxer.unbox("message")
        self.result = unboxer.unbox("result")
    }
}

struct FriendResult: Unboxable {
    
    let friendList: [FriendInfo]
    let message: String
    let result: Bool
    
    init(unboxer: Unboxer) {
        self.friendList = unboxer.unbox("friendList")
        self.message = unboxer.unbox("message")
        self.result = unboxer.unbox("result")
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
    
    init(unboxer: Unboxer) {
        self.address = unboxer.unbox("address")
        self.id = unboxer.unbox("id")
        self.mail_addr = unboxer.unbox("mail_addr")
        self.minister = unboxer.unbox("minister")
        self.mobile = unboxer.unbox("mobile")
        self.name = unboxer.unbox("name")
        self.tel = unboxer.unbox("tel")
    }
}
