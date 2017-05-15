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
    
    init(unboxer: Unboxer) throws {
		self.message = try! unboxer.unbox(key: "message")
        self.result = try! unboxer.unbox(key: "result")
    }
}

internal struct LoginCheckResult: Unboxable {
    
//    let message: String
    let result: Bool
    let status: LoginCheckStatus
    
    init(unboxer: Unboxer) throws {
//        self.message = unboxer.unbox("message")
        self.result = try! unboxer.unbox(key: "result")
        self.status = try! unboxer.unbox(key: "status")
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
    
    init(unboxer: Unboxer) throws {
        self.message = try! unboxer.unbox(key: "message")
        self.result = try! unboxer.unbox(key: "result")
		self.id = try! unboxer.unbox(key: "id")
    }
}

internal struct LogoutResult: Unboxable {
	
	let result: Bool

	init(unboxer: Unboxer) throws {
		self.result = try! unboxer.unbox(key: "result")
	}
}
