//
//  HDZUserDefaults.swift
//  seller
//
//  Created by NakaharaShun on 6/19/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import Foundation


internal class HDZUserDefaults {

    // MARK: - UUID
    private static let KEY_USER_DEFAULTS_UUID: String = "key_user_defaults_uuid"
    
    internal class var uuid: String {
        get {
            // Old UUID
            let userDefaults = UserDefaults.standard
            if let oldUUID: String = userDefaults.string(forKey: KEY_USER_DEFAULTS_UUID) {
				return oldUUID
//                if self.initialization {
//                    return oldUUID
//                }
            }
            
            // New UUID
            let newUUID: NSUUID = NSUUID()
            let uuidString: String = newUUID.uuidString
            userDefaults.setValue(uuidString, forKey: KEY_USER_DEFAULTS_UUID)
            userDefaults.synchronize()
//            self.initialization = true
			
            return uuidString
        }
    }

    // MARK: - ID
    private static let KEY_USER_DEFAULTS_ID: String = "key_user_defaults_id"
    
    internal class var id: String {
        get {
            let userDefaults = UserDefaults.standard
			if let response:String = userDefaults.string( forKey: KEY_USER_DEFAULTS_ID ) {
				return response
			}
            return ""
        }
        set {
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(newValue, forKey: KEY_USER_DEFAULTS_ID)
            userDefaults.synchronize()
        }
    }
	
	// MARK: - LOGIN_ID
	private static let KEY_USER_DEFAULTS_LOGIN_ID:String = "key_user_defaults_login_id"
	
	internal class var login_id: String {
		get {
			let userDefaults = UserDefaults.standard
			if let response:String = userDefaults.string( forKey: KEY_USER_DEFAULTS_LOGIN_ID ) {
				return response
			}
			return ""
		}
		set {
			let userDefaults = UserDefaults.standard
			userDefaults.setValue(newValue, forKey: KEY_USER_DEFAULTS_LOGIN_ID)
			userDefaults.synchronize()
		}
	}

    // MARK: - Initialization
//    private static let KEY_USER_DEFAULTS_INITIALIZATION: String = "key_user_defaults_initialization"
//    
//    internal class var initialization: Bool {
//        get {
//            let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
//            return userDefaults.boolForKey(KEY_USER_DEFAULTS_INITIALIZATION)
//        }
//        set {
//            let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
//            userDefaults.setBool(newValue, forKey: KEY_USER_DEFAULTS_INITIALIZATION)
//            userDefaults.synchronize()
//        }
//    }
	
    // MARK: - Login
    private static let KEY_USER_DEFAULTS_LOGIN: String = "key_user_defaults_login"
    
    internal class var login: Bool {
        get {
            let userDefaults = UserDefaults.standard
            return userDefaults.bool(forKey: KEY_USER_DEFAULTS_LOGIN)
        }
        set {
//            if !newValue {
//                self.initialization = false
//            }
			
            let userDefaults = UserDefaults.standard
            userDefaults.set(newValue, forKey: KEY_USER_DEFAULTS_LOGIN)
            userDefaults.synchronize()
        }
    }
    
    // MARK: - DeviceToken
	private static let KEY_USER_DEFAULTS_DEVICETOKEN: String = "key_user_defaults_device_token"
	
	internal class var devicetoken: String {
		get {
			let userDefaults = UserDefaults.standard
			if let response:String = userDefaults.string(forKey: KEY_USER_DEFAULTS_DEVICETOKEN) {
				return response
			}
			return ""
		}
		set {
			let userDefaults = UserDefaults.standard
			userDefaults.set(newValue, forKey: KEY_USER_DEFAULTS_DEVICETOKEN)
			userDefaults.synchronize()
		}
	}	
}
