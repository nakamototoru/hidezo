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
        let bundle = Bundle.main
        let storyBoard: UIStoryboard = UIStoryboard(name: name, bundle: bundle)
        return storyBoard.instantiateInitialViewController() as! T
    }

    internal class func createViewController<T: UIViewController>(name: String, withIdentifier identifier: String) -> T {
        let bundle = Bundle.main
        let storyBoard: UIStoryboard = UIStoryboard(name: name, bundle: bundle)
        return storyBoard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
    internal func deleteBackButtonTitle() {
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButtonItem
    }
}
