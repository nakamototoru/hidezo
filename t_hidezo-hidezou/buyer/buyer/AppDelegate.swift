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


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
//        Fabric.with([Crashlytics.self])

		#if DEBUG
		debugPrint("------------ didFinishLaunchingWithOptions ----------")
        if !HDZUserDefaults.login {
//            HDZUserDefaults.id = ""
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
		UINavigationBar.appearance().tintColor = UIColor.whiteColor()
		//ナビゲーションバーの背景を変更
		UINavigationBar.appearance().barTintColor = buyerColor
		//ナビゲーションのタイトル文字列の色を変更
		UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
		
		// タブバー
		//タブバーの色
		//[UITabBar appearance].barTintColor = [UIColor appColor];
		UITabBar.appearance().barTintColor = buyerColor

		// fontの設定
		let fontFamily: UIFont! = UIFont.systemFontOfSize(10)
		
		// 選択時の設定
		let selectedColor:UIColor = UIColor.blackColor()
		let selectedAttributes = [NSFontAttributeName: fontFamily, NSForegroundColorAttributeName: selectedColor]
		/// タイトルテキストカラーの設定
		UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, forState: UIControlState.Selected)
		/// アイコンカラーの設定
		UITabBar.appearance().tintColor = selectedColor
		
		// 非選択時の設定
		let nomalAttributes = [NSFontAttributeName: fontFamily, NSForegroundColorAttributeName: UIColor.whiteColor()]
		/// タイトルテキストカラーの設定
		UITabBarItem.appearance().setTitleTextAttributes(nomalAttributes, forState: UIControlState.Normal)
		
		// !!!:dezami
		// プッシュ通知
		// バッジ、サウンド、アラートをリモート通知対象として登録する
		let settings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories:nil)
		UIApplication.sharedApplication().registerUserNotificationSettings(settings)
		UIApplication.sharedApplication().registerForRemoteNotifications()
		
		// アプリが起動していない時にpush通知が届き、push通知から起動した場合
		if (launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey]) != nil {
			//全ての通知を削除する場合
			//		UIApplication.sharedApplication().cancelAllLocalNotifications()
			//		UIApplication.sharedApplication().applicationIconBadgeNumber = -1
		}
		
		// デバイストークン送信
		if HDZUserDefaults.login && HDZUserDefaults.devicetoken != "" {
			HDZApi.postDeviceTokenByLogin()
		}
		
		// !!!:deploygate
		DeployGateSDK.sharedInstance().launchApplicationWithAuthor("dezamisystem", key: "ab3219a7cb8eefbc04bc0ebe0af036b97d82ae4f")
		
		// !!!:プレゼンテーション用
//		let aSelector = #selector(AppDelegate.tapGesture(_:))
//		let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
//		window?.addGestureRecognizer(tapGesture)
		
        return true
    }

	// ジェスチャーイベント処理
	func tapGesture(gestureRecognizer: UITapGestureRecognizer){

		let point = gestureRecognizer.locationOfTouch(0, inView: window)
		
		debugPrint(point)
	}
	
	//
	// MARK: - デバイスが通知許可してPush通知の登録が完了した場合、deviceTokenが返される
	func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData ) {
		
//		print(">>>> deviceToken: \(deviceToken.description)")
		
		let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
		
		let deviceTokenString: String = ( deviceToken.description as NSString )
			.stringByTrimmingCharactersInSet( characterSet )
			.stringByReplacingOccurrencesOfString( " ", withString: "" ) as String

		DeployGateExtra.DGSLog("デバイス通知許可\n didRegisterForRemoteNotificationsWithDeviceToken\n <deviceToken>: " + deviceTokenString)

		// デバイスに保存
		HDZUserDefaults.devicetoken = deviceTokenString
		
		//ログイン状態
		if HDZUserDefaults.login {
			#if DEBUG
			debugPrint("Now Login")
			#endif
			
			HDZApi.postDeviceTokenByLogin()
		}

	}

	// MARK: - Push通知が利用不可であればerrorが返ってくる
	func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
		DeployGateExtra.DGSLog("didFailToRegisterForRemoteNotificationsWithError: " + "\(error)")
	}
	
	// リモート通知で受け取ったデータの解析
	private func receiveRemoteNotification(userInfo:[NSObject:AnyObject]) {
		// カスタムデータ
		guard let dict:[NSObject : AnyObject] = userInfo else {
			DeployGateExtra.DGSLog(">> No userInfo found in RemoteNotification")
			return
		}
		
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
					let pushAps:PushApsResult = try Unbox(value as! UnboxableDictionary)
					//... パース成功...
					// ダイアログ
					MyWarning.Warning(pushAps.alert)
					
					// TODO:最後の通知のみダイアログ表示
					// スタックに保存
//					HDZPushNotificationManager.appendPushAps(pushAps)
					
				} catch {
					DeployGateExtra.DGSLog("... パース失敗...")
				}
			}
		}
		
		// バッジチェック
		if HDZUserDefaults.login {
			DeployGateExtra.DGSLog("AppDelegate.didReceiveRemoteNotification : Check Badge");
			// プッシュ通知のcustom_dataをサーバーAPIから受け取る
			HDZPushNotificationManager.checkBadge()
		}
	}
	
	// MARK: - Push通知受信時とPush通知をタッチして起動したときに呼ばれる
	//アクティブ時のみ呼び出される
	func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
		
		DeployGateExtra.DGSLog("**** didReceiveRemoteNotification ****")
		
//		switch application.applicationState {
//		case .Inactive:
//			// アプリがバックグラウンドにいる状態で、Push通知から起動したとき
//			print("> applicationState.Inactive")
//			break
//		case .Active:
//			// アプリ起動時にPush通知を受信したとき
//			print("> applicationState.Active")
//			break
//		case .Background:
//			// アプリがバックグラウンドにいる状態でPush通知を受信したとき
//			print("> applicationState.Background")
//			break
//		}
		
		// カスタムデータ
		receiveRemoteNotification(userInfo)

	}
	
	// バックグラウンドでPush通知
	func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
		
		DeployGateExtra.DGSLog("**** didReceiveRemoteNotification fetchCompletionHandler****")

		// カスタムデータ
		receiveRemoteNotification(userInfo)
		
		completionHandler(.NoData)
	}
	
	// MARK: -
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//		UIApplication.sharedApplication().applicationIconBadgeNumber = -1
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//		UIApplication.sharedApplication().applicationIconBadgeNumber = -1
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		
		// バッジチェック
		if HDZUserDefaults.login {
			DeployGateExtra.DGSLog("applicationDidBecomeActive : Check Badge");
			// プッシュ通知のcustom_dataをサーバーAPIから受け取る
			HDZPushNotificationManager.checkBadge()
		}
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        guard let host: String = url.host else {
            return true
        }
		
		// ログイン状態記録
		HDZUserDefaults.id = host
		
        return true
    }

}

