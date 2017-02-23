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
			// デバイス
			// 本番サーバー
			// TODO:申請時には本番に変更しておく
			//    return baseUrlProduct
			// 開発サーバー
			return baseUrlDev
		#endif

	}
	
}
