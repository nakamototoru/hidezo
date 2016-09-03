//
//  HDZItemOrderManager.swift
//  buyer
//
//  Created by デザミ on 2016/08/19.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZItemOrderManager: NSObject {
	
	var deliverto:String = ""
	var charge:String = ""
	var deliverdate:String = ""
	var comment:String = ""
	
	private var listDate:[String] = ["最短納品日","月曜日","火曜日","水曜日","木曜日","金曜日","土曜日","日曜日"]
	
	static let shared = HDZItemOrderManager()
	private override init() {
	}
	
	func clearAllData() {
		self.deliverto = ""
		self.charge = ""
		self.deliverdate = ""
		self.comment = ""
	}
	
	func getListDate() -> [String] {
		return self.listDate
	}
}
