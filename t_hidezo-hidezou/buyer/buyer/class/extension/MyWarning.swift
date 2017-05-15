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
		var baseView:UIViewController = (UIApplication.shared.keyWindow?.rootViewController)!
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
		
		let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
			// 閉じた後
			isOpened = false
		}
		alert.addAction(alertAction)
		
		let baseView:UIViewController = getBaseViewController()
		baseView.present(alert, animated: true) {
			// 開いた後
		}
		isOpened = true
	}
	
	internal class func Warning(message:String) {
		Warning(title: "", message: message)
	}
	
	// 一択
	internal class func Dialog(title:String, message:String, alertActionDone:UIAlertAction) {
		
		let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(alertActionDone)

		let baseView:UIViewController = getBaseViewController()
		baseView.present(alert, animated: true) {
			// 開いた後
		}
	}
	
	// 二択、実行時のみ登録
	internal class func Alert(title:String, message:String, alertActionOkey:UIAlertAction) {
		
		let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(alertActionOkey)

		let alertActionCancel = UIAlertAction(title: "キャンセル", style: .cancel) { (UIAlertAction) in
		}
		alert.addAction(alertActionCancel)
		
		let baseView:UIViewController = getBaseViewController()
		baseView.present(alert, animated: true) {
			// 開いた後
		}
	}
}
