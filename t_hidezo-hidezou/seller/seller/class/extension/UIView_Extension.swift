//
//  UIView_Extension.swift
//  seller
//
//  Created by NakaharaShun on 6/25/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit

extension UIView {
    
    internal class func createView<T: UIView>(nibName: String) -> T {
        let bundle: NSBundle = NSBundle.mainBundle()
        let nib: UINib = UINib(nibName: nibName, bundle: bundle)
        let views: [AnyObject] = nib.instantiateWithOwner(nil, options: nil)
        return views.first as! T
    }
    
    internal class func createView<T: UIView>(nibName: String, index: Int) -> T {
        let bundle: NSBundle = NSBundle.mainBundle()
        let nib: UINib = UINib(nibName: nibName, bundle: bundle)
        let views: [AnyObject] = nib.instantiateWithOwner(nil, options: nil)
        return views[index] as! T
    }
}
