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
        
        let application: UIApplication = UIApplication.sharedApplication()
        
        guard let keyWindow: UIWindow = application.keyWindow else {
            return nil
        }
        
        return keyWindow.rootViewController as? T
    }
    
    internal class func setRootViewController(viewController: UIViewController) {

        let application: UIApplication = UIApplication.sharedApplication()

        guard let keyWindow: UIWindow = application.keyWindow else {
            return
        }
        
        keyWindow.rootViewController = viewController
    }
}
