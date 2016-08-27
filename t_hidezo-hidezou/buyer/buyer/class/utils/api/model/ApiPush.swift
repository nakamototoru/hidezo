//
//  ApiPush.swift
//  buyer
//
//  Created by デザミ on 2016/08/26.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import Foundation
import Unbox
import Wrap

// MARK: - DeviceToken
// MARK: Request
internal struct DeviceToken: WrapCustomizable {
	
	let id: Int
	let uuid: String
	let device_token: String
	let device_flg: String
}

// MARK: Response
internal struct DeviceTokenResult: Unboxable {
	
	let message: String
	let result: Bool
	
	init(unboxer: Unboxer) {
		self.message = unboxer.unbox("message")
		self.result = unboxer.unbox("result")
	}
}

// MARK: - CustomData
// MARK: Response
internal struct CustomDataResult: Unboxable {
	
	let custom_data: String
	
	init(unboxer: Unboxer) {
		self.custom_data = unboxer.unbox("custom_data")
	}
}
