//
//  HDZConfiguration.swift
//  buyer
//
//  Created by 庄俊亮 on 2017/02/23.
//  Copyright © 2017年 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZConfiguration: NSObject {

	internal class func ApiBaseUrl() -> String {
		
		let baseUrlDev = "https://dev-api.hidezo.co"
		let baseUrlProduct = "https://api.hidezo.co"
		
		#if (arch(i386) || arch(x86_64)) && os(iOS)
			// シミュレータならば
			return baseUrlDev
		#else
			// デバイスならば
			if HDZConfiguration.getIsBuildProduct() {
				// 本番サーバー
				return baseUrlProduct
			}
			else {
				// 開発サーバー
				return baseUrlDev
			}
		#endif
	}
	
	internal class func getIsBuildProduct() -> Bool {
		// TODO:申請時には本番に変更しておく
		return false
		// return true
	}

}
