//
//  HDZItemOrderManager.swift
//  buyer
//
//  Created by デザミ on 2016/08/19.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZItemOrderManager: NSObject {
	
	var deliverto:String! = ""
	var charge:String! = ""
	var deliverdate:String! = ""
	
	static let shared = HDZItemOrderManager()
	private override init() {
	}
}