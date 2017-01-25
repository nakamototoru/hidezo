//
//  ApiCheckDynamicItems.swift
//  buyer
//
//  Created by デザミ on 2016/09/22.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import Foundation
import Unbox
import Wrap

internal struct CheckDynamicItemsRequest: WrapCustomizable {
	
	let id: String
	let uuid: String
	let supplier_id: String
}

internal struct CheckDynamicItemsResultError: Unboxable {
	
	let message: String
	let result: Bool
	
	init(unboxer: Unboxer) {
		self.message = unboxer.unbox("message")
		self.result = unboxer.unbox("result")
	}
}

internal struct CheckDynamicItemsResultComplete: Unboxable {
	
//	let message: String
	let result: Bool
//	let dynamic_item_update_badge_total: String
//	let comment_badge_total: String
//	let icon_badge_total: String
	
	init(unboxer: Unboxer) {
//		self.message = unboxer.unbox("message")
		self.result = unboxer.unbox("result")
		
//		self.dynamic_item_update_badge_total = unboxer.unbox("dynamic_item_update_badge_total")
//		self.comment_badge_total = unboxer.unbox("comment_badge_total");
//		self.icon_badge_total = unboxer.unbox("icon_badge_total")
	}
}
