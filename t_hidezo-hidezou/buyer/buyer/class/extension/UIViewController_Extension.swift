//
//  UIViewController_Extension.swift
//  seller
//
//  Created by NakaharaShun on 6/19/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit

extension UIViewController {
    
    internal class func createViewController<T: UIViewController>(name: String) -> T {
        let bundle: NSBundle = NSBundle.mainBundle()
        let storyBoard: UIStoryboard = UIStoryboard(name: name, bundle: bundle)
        return storyBoard.instantiateInitialViewController() as! T
    }

    internal class func createViewController<T: UIViewController>(name: String, withIdentifier identifier: String) -> T {
        let bundle: NSBundle = NSBundle.mainBundle()
        let storyBoard: UIStoryboard = UIStoryboard(name: name, bundle: bundle)
        return storyBoard.instantiateViewControllerWithIdentifier(identifier) as! T
    }
    
    internal func deleteBackButtonTitle() {
        let backButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButtonItem
    }
}
