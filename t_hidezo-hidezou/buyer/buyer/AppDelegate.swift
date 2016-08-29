//
//  AppDelegate.swift
//  seller
//
//  Created by NakaharaShun on 6/19/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

import Alamofire
import Unbox


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Fabric.with([Crashlytics.self])
        
        if !HDZUserDefaults.login {
//            HDZUserDefaults.id = ""
        }
		
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
		UIApplication.sharedApplication().registerForRemoteNotifications()
		UIApplication.sharedApplication().registerUserNotificationSettings(settings)
		
		if (launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey]) != nil {
			// アプリが起動していない時にpush通知が届き、push通知から起動した場合
			//全ての通知を削除
			UIApplication.sharedApplication().cancelAllLocalNotifications()
			UIApplication.sharedApplication().applicationIconBadgeNumber = -1
		}
		
        return true
    }

	// デバイスが通知許可してPush通知の登録が完了した場合、deviceTokenが返される
	func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData ) {
		print("deviceToken: \(deviceToken.description)")
		
		// デバイスに保存
		HDZUserDefaults.devicetoken = deviceToken.description
		
		//ログイン状態
		if HDZUserDefaults.login {
			debugPrint("Now Login")
		}

	}

	// Push通知が利用不可であればerrorが返ってくる
	func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
		NSLog("error: " + "\(error)")
	}
	
	// Push通知受信時とPush通知をタッチして起動したときに呼ばれる
	func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
		switch application.applicationState {
		case .Inactive:
			// アプリがバックグラウンドにいる状態で、Push通知から起動したとき
			NSLog("applicationState.Inactive")
			break
		case .Active:
			// アプリ起動時にPush通知を受信したとき
			NSLog("applicationState.Active")
			break
		case .Background:
			// アプリがバックグラウンドにいる状態でPush通知を受信したとき
			NSLog("applicationState.Background")
			break
		}
		//全ての通知を削除
		UIApplication.sharedApplication().cancelAllLocalNotifications()
		UIApplication.sharedApplication().applicationIconBadgeNumber = -1

		
		// カスタムデータ
		guard let dict:[NSObject : AnyObject] = userInfo else {
			print("No userInfo found in RemoteNotification")
			return
		}
		#if DEBUG
		debugPrint("Remote UserInfo")
		#endif
		for (key, value) in dict {
			
			let strkey:String = key as! String
			if strkey != "aps" {
				#if DEBUG
				debugPrint(strkey)
				debugPrint(value)
				debugPrint("/")
				#endif
			}
		}
		
	}
	
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
		UIApplication.sharedApplication().applicationIconBadgeNumber = -1
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
		UIApplication.sharedApplication().applicationIconBadgeNumber = -1
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        guard let host: String = url.host else {
            return true
        }
		HDZUserDefaults.id = host
		
//        if let id: String = Int(host) {
//        }
		
        return true
    }

}

