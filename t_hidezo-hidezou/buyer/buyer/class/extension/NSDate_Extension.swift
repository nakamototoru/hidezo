//
//  NSDate_Extension.swift
//  buyer
//
//  Created by Shun Nakahara on 7/31/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import Foundation

extension NSDate {
    
    internal func toString(dateFormatter: NSDateFormatter) -> String {
        return dateFormatter.stringFromDate(self)
    }    
}