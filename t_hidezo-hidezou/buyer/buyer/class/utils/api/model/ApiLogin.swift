//
//  ApiLogin.swift
//  seller
//
//  Created by NakaharaShun on 6/20/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import Foundation
import Unbox
import Wrap

internal enum LoginCheckStatus: String, UnboxableEnum {

    case update = "UPDATE"
    case new = "NEW"
    case none = "NONE"
    
    static func unboxFallbackValue() -> LoginCheckStatus {
        return .none
    }
}

internal struct LoginCheck: WrapCustomizable {
    
    let id: String
//	let login_id:String
    let uuid: String
    let password: String
}

internal struct LoginCheckError: Unboxable {
    
    let message: String
    let result: Bool
    
    init(unboxer: Unboxer) {
        self.message = unboxer.unbox("message")
        self.result = unboxer.unbox("result")
    }
}

internal struct LoginCheckResult: Unboxable {
    
//    let message: String
    let result: Bool
    let status: LoginCheckStatus
    
    init(unboxer: Unboxer) {
//        self.message = unboxer.unbox("message")
        self.result = unboxer.unbox("result")
        self.status = unboxer.unbox("status")
    }
}

internal struct Login: WrapCustomizable {
    
//    let id: String
	let login_id:String
    let uuid: String
//    let password: String
	let pass: String
	let device_div:String
}

internal struct LoginResult: Unboxable {
    
    let message: String
    let result: Bool
	let id:String
    
    init(unboxer: Unboxer) {
        self.message = unboxer.unbox("message")
        self.result = unboxer.unbox("result")
		self.id = unboxer.unbox("id")
    }
}
