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
    
    init(unboxer: Unboxer) {
        self.message = unboxer.unbox("message")
        self.result = unboxer.unbox("result")
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
    
    init(unboxer: Unboxer) {
//        self.message = unboxer.unbox("message")
        self.result = unboxer.unbox("result")

        self.address = unboxer.unbox("me.address", isKeyPath: true)
        self.mail_address = unboxer.unbox("me.mail_address", isKeyPath: true)
        self.minister = unboxer.unbox("me.minister", isKeyPath: true)
        self.mobile = unboxer.unbox("me.mobile", isKeyPath: true)
        self.name = unboxer.unbox("me.name", isKeyPath: true)
        self.tel = unboxer.unbox("me.tel", isKeyPath: true)
    }
}
