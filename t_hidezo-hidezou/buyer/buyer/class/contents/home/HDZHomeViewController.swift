//
//  HDZHomeViewController.swift
//  seller
//
//  Created by NakaharaShun on 6/20/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZHomeViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		// !!!:・デザミシステム
		// アイコンカラー（画像）の設定
		var assets :Array<String> = ["maru", "maru", "maru"]
		for (idx, item) in self.tabBar.items!.enumerate() {
			item.image = UIImage(named: assets[idx])?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
		}
		
		// !!!:タブバーへバッジ表示
		//self.tabBarController?.tabBar.items![0].badgeValue = "3" // 下階層から呼ぶ場合
		self.updateBadgeSupplier()
		self.updateBadgeMessage()

		// !!!:バッジ通知
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HDZHomeViewController.getNotificationSupplier(_:)), name: HDZPushNotificationManager.shared.strNotificationSupplier, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HDZHomeViewController.getNotificationMessage(_:)), name: HDZPushNotificationManager.shared.strNotificationMessage, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	// !!!:通知受け取り時
	func getNotificationSupplier(notification: NSNotification)  {
		
		self.updateBadgeSupplier()
	}
	
	func getNotificationMessage(notification: NSNotification) {
		
		self.updateBadgeMessage()
	}
	
	func updateBadgeSupplier() {
		
		// 商品更新
		let list:[SupplierId] = HDZPushNotificationManager.shared.getSupplierUpList()
		let count:Int = list.count
		if count > 0 {
			self.tabBar.items![0].badgeValue = String(count)
		}
//		else {
//			self.tabBar.items![0].badgeValue = String(-1)
//		}
	}
	
	func updateBadgeMessage() {
		
		// メッセージ更新
		let list:[MessageUp] = HDZPushNotificationManager.shared.getMessageUpList()
		var count:Int = 0
		for obje:MessageUp in list {
			let num:Int = Int( obje.messageCount )!
			count += num
		}
		if count > 0 {
			self.tabBar.items![1].badgeValue = String(count)
		}
//		else {
//			self.tabBar.items![1].badgeValue = String(-1)
//		}
	}

	deinit {
		//イベントリスナーの削除
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
}

extension HDZHomeViewController {
    
    internal class func createViewController() -> HDZHomeViewController {
        return UIViewController.createViewController("HDZHomeViewController")
    }
}
