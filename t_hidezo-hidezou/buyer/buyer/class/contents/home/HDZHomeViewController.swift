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
		
		// 型チェック用に設定
		self.title = "HDZHomeViewController"
		
		// !!!:・デザミシステム
		// アイコンカラー（画像）の設定
		var assets :Array<String> = ["profile_white", "order_white"]
		for (idx, item) in self.tabBar.items!.enumerated() {
			item.image = UIImage(named: assets[idx])?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
		}
		
		// !!!:タブバーへバッジ表示
		//self.tabBarController?.tabBar.items![0].badgeValue = "3" // 下階層から呼ぶ場合
		self.updateBadgeSupplier()
		self.updateBadgeMessage()

		// !!!:バッジ通知の受取
		NotificationCenter.default.addObserver(self, selector: #selector(getNotificationSupplier), name: HDZPushNotificationManager.shared.strNotificationSupplier, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(getNotificationMessage), name: HDZPushNotificationManager.shared.strNotificationMessage, object: nil)
    }

//	override func viewWillAppear(animated: Bool) {
//		super.viewWillAppear(animated)
//		
//	}
	
//	override func viewDidAppear(animated: Bool) {
//		super.viewDidAppear(animated)
//		
//	}
	
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
		
		// 商品更新バッジ
		HDZPushNotificationManager.updateSupplierBadgeWithTabBar(tabBar: self.tabBar)
	}
	
	func updateBadgeMessage() {
		
		// メッセージ更新バッジ
		HDZPushNotificationManager.updateMessageBadgeWithTabBar(tabBar: self.tabBar)
	}

	deinit {
		//イベントリスナーの削除
		NotificationCenter.default.removeObserver(self)
	}
	
}

extension HDZHomeViewController {
    
    internal class func createViewController() -> HDZHomeViewController {
        return UIViewController.createViewController(name: "HDZHomeViewController")
    }
}
