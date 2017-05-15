//
//  UIApplication_Extension.swift
//  seller
//
//  Created by NakaharaShun on 6/19/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit

extension UIApplication {
    
    // MARK: - root view controller
    internal class func getRootViewController<T: UIViewController>() -> T? {
        
        let application: UIApplication = UIApplication.shared
        
        guard let keyWindow: UIWindow = application.keyWindow else {
            return nil
        }
        
        return keyWindow.rootViewController as? T
    }
    
    internal class func setRootViewController(viewController: UIViewController) {

        let application: UIApplication = UIApplication.shared

        guard let keyWindow: UIWindow = application.keyWindow else {
            return
        }
        
        keyWindow.rootViewController = viewController
    }
	
	// MARK: - 親ビューコンをなんとか検索
	internal class func getBaseViewController() -> UIViewController? {
		
		var baseView:UIViewController = (UIApplication.shared.keyWindow?.rootViewController)!
		
		while baseView.presentedViewController != nil && !(baseView.presentedViewController?.isBeingDismissed)! {
			baseView = baseView.presentedViewController!
		}
		
		return baseView
	}
	
	// MARK: - 最前面のUIViewControllerを取得
	var topViewController: UIViewController? {
		
		guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else {
			return nil
		}
		
		while let presentedViewController = topViewController.presentedViewController {
			topViewController = presentedViewController
		}
		
		return topViewController
	}
	
	var topNavigationController: UINavigationController? {
		
		return topViewController as? UINavigationController
	}
	
	// MARK: - 高さ
	class func statusBarHeight() -> CGFloat {
		return UIApplication.shared.statusBarFrame.height
	}

}
