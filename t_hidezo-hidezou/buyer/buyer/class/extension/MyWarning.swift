//
//  MyWarning.swift
//  buyer
//
//  Created by 庄俊亮 on 2017/01/05.
//  Copyright © 2017年 Shun Nakahara. All rights reserved.
//

import UIKit

class MyWarning: NSObject {

	private static var isOpened:Bool = false
	
	internal class func getBaseViewController() -> UIViewController {
		// 親ビューコンをなんとか検索
		var baseView:UIViewController = (UIApplication.sharedApplication().keyWindow?.rootViewController)!
		while baseView.presentedViewController != nil && !(baseView.presentedViewController?.isBeingDismissed())! {
			baseView = baseView.presentedViewController!
		}
		return baseView
	}
	
	// 警告を表示します。OKボタンタップで閉じます。
	internal class func Warning(title:String, message:String) {
		
		if isOpened {
			return
		}
		
		let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
		let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (UIAlertAction) in
			// 閉じた後
			isOpened = false
		}
		alert.addAction(alertAction)
		
		let baseView:UIViewController = getBaseViewController()
		baseView.presentViewController(alert, animated: true) {
			// 開いた後
		}
		isOpened = true
	}
	
	internal class func Warning(message:String) {
		Warning("", message: message)
	}
	
}
