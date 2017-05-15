//
//  NSDate_Extension.swift
//  buyer
//
//  Created by Shun Nakahara on 7/31/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import Foundation

extension Date {
    
    internal func toString(dateFormatter: DateFormatter) -> String {
        return dateFormatter.string(from: self)
    }    
}
