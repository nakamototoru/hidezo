//
//  AppConf.swift
//  buyer
//
//  Created by 庄俊亮 on 2017/02/23.
//  Copyright © 2017年 Shun Nakahara. All rights reserved.
//

import UIKit

class AppConf: NSObject {

	private static let sharedInstance = AppConf()
	private var configuration: String
	private var variables: [String: AnyObject]
	
	private override init() {
		
		// Singletonの確認用
		debugPrint("Configuration initialization")
		
		let mainBundle = NSBundle.mainBundle()
		// Fetch Current Configuration
		self.configuration = (mainBundle.infoDictionary?["Configuration"]) as! String
		
		debugPrint("Current Configuration = \(self.configuration)")
		
		// Load Configurations
		guard let path = mainBundle.pathForResource("Configuration", ofType: "plist") else {
			self.variables = [:]
			return
		}
		let configurations =  NSDictionary(contentsOfFile: path)
		// Load Variables for Current Configuration
		self.variables = configurations?.objectForKey(self.configuration) as! [String : AnyObject]
	}
	
	class func Configuration() -> String {
		return sharedInstance.configuration
	}
	
	class func ApiBaseUrl() -> String {
		guard let endpoint = sharedInstance.variables["ApiBaseUrl"] else {
			return ""
		}
		return endpoint as! String
	}
	
}
