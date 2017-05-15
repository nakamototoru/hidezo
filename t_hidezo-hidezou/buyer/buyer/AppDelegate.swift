//
//  AppDelegate.swift
//  seller
//
//  Created by NakaharaShun on 6/19/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit
//import Fabric
//import Crashlytics
import Unbox


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

	
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
		//        Fabric.with([Crashlytics.self])
		
		#if DEBUG
		debugPrint("------------ didFinishLaunchingWithOptions ----------")
        if !HDZUserDefaults.login {
			debugPrint("Out of Login")
        }
		else {
			debugPrint("Now Login")
		}
		#endif
		
		// !!!:デザミシステム
		let buyerColor:UIColor = UIColor(red: 44.0/255, green: 166.0/255, blue: 224.0/255, alpha: 1)
		//ナビゲーションバーの色
		//ナビゲーションアイテムの色を変更
		UINavigationBar.appearance().tintColor = UIColor.white
		//ナビゲーションバーの背景を変更
		UINavigationBar.appearance().barTintColor = buyerColor
		//ナビゲーションのタイトル文字列の色を変更
		UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
		
		// タブバー
		//タブバーの色
		//[UITabBar appearance].barTintColor = [UIColor appColor];
		UITabBar.appearance().barTintColor = buyerColor

		// fontの設定
		let fontFamily: UIFont! = UIFont.systemFont(ofSize: 10)
		
		// 選択時の設定
		let selectedColor:UIColor = UIColor.black
		let selectedAttributes = [NSFontAttributeName: fontFamily, NSForegroundColorAttributeName: selectedColor] as [String : Any]
		/// タイトルテキストカラーの設定
		UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, for: UIControlState.selected)
		/// アイコンカラーの設定
		UITabBar.appearance().tintColor = selectedColor
		
		// 非選択時の設定
		let nomalAttributes = [NSFontAttributeName: fontFamily, NSForegroundColorAttributeName: UIColor.white] as [String : Any]
		/// タイトルテキストカラーの設定
		UITabBarItem.appearance().setTitleTextAttributes(nomalAttributes, for: UIControlState.normal)
		
		// !!!:dezami
		// プッシュ通知
		// バッジ、サウンド、アラートをリモート通知対象として登録する
		let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories:nil)
		UIApplication.shared.registerUserNotificationSettings(settings)
		UIApplication.shared.registerForRemoteNotifications()
		// デバイストークン送信
		if HDZUserDefaults.login && HDZUserDefaults.devicetoken != "" {
			HDZApi.postDeviceTokenByLogin()
		}
		
		// !!!:deploygate
		DeployGateSDK.sharedInstance().launchApplication(withAuthor: "dezamisystem", key: "ab3219a7cb8eefbc04bc0ebe0af036b97d82ae4f")
		
        return true
    }

	// ジェスチャーイベント処理
//	func tapGesture(gestureRecognizer: UITapGestureRecognizer){
//
//		let point = gestureRecognizer.location(ofTouch: 0, in: window)
//		
//		debugPrint(point)
//	}
	
	//
	// MARK: - デバイスが通知許可してPush通知の登録が完了した場合、deviceTokenが返される
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data ) {

//		let stringData = deviceToken.description
//		let deviceTokenString = stringData.trimmingCharacters(in: CharacterSet.init(charactersIn: "<>"))
//			.replacingOccurrences(of: " ", with: "")
//			.uppercased()
		
		let token = deviceToken.map { String(format: "%.2hhx", $0) }.joined()
		
		DeployGateExtra.dgsLog("デバイス通知許可\n didRegisterForRemoteNotificationsWithDeviceToken\n <deviceToken>: " + token)

		// デバイスに保存
		HDZUserDefaults.devicetoken = token
		
		//ログイン状態
		if HDZUserDefaults.login {
			#if DEBUG
			debugPrint("Now Login")
			#endif
			
			HDZApi.postDeviceTokenByLogin()
		}

	}

	// MARK: - Push通知が利用不可であればerrorが返ってくる
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		DeployGateExtra.dgsLog("didFailToRegisterForRemoteNotificationsWithError: " + "\(error)")
	}
	
	// リモート通知で受け取ったデータの解析
	private func receiveRemoteNotification(userInfo:[AnyHashable:Any]) {
		
		DeployGateExtra.dgsLog(">receiveRemoteNotification")
		
		// カスタムデータ
		let dict = userInfo
//		guard let dict = userInfo else {
//			DeployGateExtra.dgsLog(">> No userInfo found in RemoteNotification")
//			return
//		}
		
		// JSONパーサー
		for (key, value) in dict {
			
			let strkey:String = key as! String
			if strkey == "aps" {
				#if DEBUG
					debugPrint(strkey)
					debugPrint(value)
				#endif
				
				do {
					#if DEBUG
						debugPrint("パーサー：APS")
					#endif
					//let pushAps:PushApsResult = try unbox(value as! UnboxableDictionary)
					let pushAps:PushApsResult = try unbox(dictionary: value as! UnboxableDictionary)
					
					//... パース成功...
					DeployGateExtra.dgsLog("Message = " + pushAps.alert)
					// ダイアログ
					//MyWarning.Warning(pushAps.alert)
					UIAlertController(title: "", message: pushAps.alert, preferredStyle: .alert)
						.addAction(title: "OK", style: .default, handler: nil)
						.show()
					
				} catch {
					DeployGateExtra.dgsLog("... パース失敗...")
				}
			}
		}
		
		// バッジチェック
		if HDZUserDefaults.login {
			DeployGateExtra.dgsLog("AppDelegate.didReceiveRemoteNotification : Check Badge");
			// プッシュ通知のcustom_dataをサーバーAPIから受け取る
			HDZPushNotificationManager.checkBadge()
		}
	}
	
	// MARK: - Push通知受信時とPush通知をタッチして起動したときに呼ばれる
	//アクティブ時のみ呼び出される
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
		
		DeployGateExtra.dgsLog("**** didReceiveRemoteNotification ****")
		
		// カスタムデータ
		receiveRemoteNotification(userInfo: userInfo)
	}
	
	// バックグラウンドでPush通知
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		
		DeployGateExtra.dgsLog("**** didReceiveRemoteNotification fetchCompletionHandler****")

		// カスタムデータ
		receiveRemoteNotification(userInfo: userInfo)
		
		completionHandler(.noData)
	}
	
	
	// MARK: -
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//		UIApplication.sharedApplication().applicationIconBadgeNumber = -1
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//		UIApplication.sharedApplication().applicationIconBadgeNumber = -1
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		
		// バッジチェック
		if HDZUserDefaults.login {
			DeployGateExtra.dgsLog("applicationDidBecomeActive : Check Badge");
			// プッシュ通知のcustom_dataをサーバーAPIから受け取る
			HDZPushNotificationManager.checkBadge()
		}
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

//    func application(_ application: UIApplication, handleOpenURL url: NSURL) -> Bool {
//        guard let host: String = url.host else {
//            return true
//        }
//		
//		// ログイン状態記録
//		HDZUserDefaults.id = host
//		
//        return true
//    }
	func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
		guard let host: String = url.host else {
			return true
		}
		
		// ログイン状態記録
		HDZUserDefaults.id = host
		
		return true
	}

}

