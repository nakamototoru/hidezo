//
//  NSDateFormatter_Extension.swift
//  buyer
//
//  Created by Shun Nakahara on 7/31/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import Foundation

enum DateFormatType: String {
    case DateTime = "yyyy-MM-dd HH:mm:ss"
    case DynamicDateTime = "MM/dd(EEE)HH:mm"
	case JapanesedateTime = "yyyy/MM/dd"
}

extension DateFormatter {
    
    convenience init(type: DateFormatType) {
        self.init()
        self.dateFormat = type.rawValue
    }
}
