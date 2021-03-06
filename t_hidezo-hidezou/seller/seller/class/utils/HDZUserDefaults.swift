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
            let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
			//  .string(forKey: KEY_USER_DEFAULTS_UUID)
            if let oldUUID: String = userDefaults.stringForKey(KEY_USER_DEFAULTS_UUID) {
                if self.initialization {
                    return oldUUID
                }
            }
            
            // New UUID
            let newUUID: NSUUID = NSUUID()
            let uuidString: String = newUUID.UUIDString // .uuidString
            //userDefaults.set(uuidString, forKey: KEY_USER_DEFAULTS_UUID)
			userDefaults.setValue(uuidString, forKey: KEY_USER_DEFAULTS_UUID)
            userDefaults.synchronize()
            self.initialization = true
            
            return uuidString
        }
    }

    // MARK: - ID
    private static let KEY_USER_DEFAULTS_ID: String = "key_user_defaults_id"
    
    internal class var id: Int {
        get {
            let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            return userDefaults.integerForKey(KEY_USER_DEFAULTS_ID)
        }
        set {
            let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setValue(newValue, forKey: KEY_USER_DEFAULTS_ID)
            userDefaults.synchronize()
        }
    }

    // MARK: - Initialization
    private static let KEY_USER_DEFAULTS_INITIALIZATION: String = "key_user_defaults_initialization"
    
    internal class var initialization: Bool {
        get {
            let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            return userDefaults.boolForKey(KEY_USER_DEFAULTS_INITIALIZATION)
        }
        set {
            let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setValue(newValue, forKey: KEY_USER_DEFAULTS_INITIALIZATION)
            userDefaults.synchronize()
        }
    }
    
    // MARK: - Login
    private static let KEY_USER_DEFAULTS_LOGIN: String = "key_user_defaults_login"
    
    internal class var login: Bool {
        get {
            let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            return userDefaults.boolForKey(KEY_USER_DEFAULTS_LOGIN)
        }
        set {
            
            if !newValue {
                self.initialization = false
            }
            
            let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setValue(newValue, forKey: KEY_USER_DEFAULTS_LOGIN)
            userDefaults.synchronize()
        }
    }
}
