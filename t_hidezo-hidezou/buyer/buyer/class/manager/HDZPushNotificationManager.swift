//
//  HDZPushNotificationManager.swift
//  buyer
//
//  Created by デザミ on 2016/08/30.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZPushNotificationManager: NSObject {

	var supplierUpList:SupplierUpListResult! = nil
	var messageUpList:MessageUpListResult! = nil
	
	static let shared = HDZPushNotificationManager()
	private override init() {
	}

}
