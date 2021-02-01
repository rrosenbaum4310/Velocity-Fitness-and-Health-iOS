//
//  GlobalManager.swift
//  ServSearch
//
//  Created by Vishal Gohel on 8/1/17.
//  Copyright © 2017 Vishal Gohel. All rights reserved.
//

import Foundation
import CloudKit

class GlobalManager: NSObject {
    
    private var token = ""
    
    private var isLoggedIn = false
    private var lastLoginDateTime : Date? = nil
    private var deviceToken = ""
    private var emailAddress = ""
    private var password = ""
    private var user: User? = nil
    
    class var sharedInstance: GlobalManager {
        struct Singleton {
            static let instance = GlobalManager()
        }
        return Singleton.instance
    }
    
    override init() {
        super.init()
        self.initialSetup()
    }
    
    func initialSetup() {
        
        if (UserDefaults.standard.object(forKey: UserDefaults.keys.userDefaultsKey) != nil) {
            let decoded  = UserDefaults.standard.object(forKey: UserDefaults.keys.userDefaultsKey) as! NSData
            //NSKeyedUnarchiver.unarchivedObject(ofClass: <#T##NSCoding.Protocol#>, from: <#T##Data#>)
            self.user = NSKeyedUnarchiver.unarchiveObject(with: decoded as Data) as? User
        }
        
        if let aToken = UserDefaults.standard.object(forKey: UserDefaults.keys.accessToken) as? String {
            self.token = aToken
        }
        if let adeviceToken = UserDefaults.standard.object(forKey: UserDefaults.keys.deviceToken) as? String {
            self.deviceToken = adeviceToken
        }
        
        if let aIsLoggedIn = UserDefaults.standard.object(forKey: UserDefaults.keys.isLoggedIn) as? Bool {
            self.isLoggedIn = aIsLoggedIn
        }
        
        if let aEmail = UserDefaults.standard.object(forKey: UserDefaults.keys.EmailAddress) as? String {
            self.emailAddress = aEmail
        }
        if let aPassword = UserDefaults.standard.object(forKey: UserDefaults.keys.Password) as? String {
            self.password = aPassword
        }
        
    }
    
    func setAccessToken(token atoken:String) {
        UserDefaults.standard.set(atoken, forKey: UserDefaults.keys.accessToken)
        UserDefaults.standard.synchronize()
        //self.setLoginStatus(status: true)
        self.token = atoken
    }
        
    func getAccessToken() -> String {
        return self.token
    }
        
    func getLoginStatus() ->  Bool
    {
      return self.isLoggedIn
    }
    func setCurrentUser(aUser:User) {
        
        let userDefaults = UserDefaults.standard
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: aUser)
        userDefaults.set(encodedData, forKey: UserDefaults.keys.userDefaultsKey)
        //userDefaults.set(aUser.referralCode, forKey: "referral")
        userDefaults.synchronize()
        self.setLoginStatus(status: true)
        self.user = aUser
    }
    
    func getCurrentUser() -> User? {
        return ((self.user) != nil) ? self.user : nil
    }
     func setLoginStatus(status : Bool)
        {
            self.isLoggedIn = status
            if status {
                UserDefaults.standard.set(status, forKey: UserDefaults.keys.isLoggedIn)
                UserDefaults.standard.synchronize()
            }
            else
            {
                UserDefaults.standard.removeObject(forKey: UserDefaults.keys.isLoggedIn)
                 UserDefaults.standard.synchronize()
            }
    }
    
    func setDeviceToken(String deviceId:String) {
        UserDefaults.standard.set(deviceId, forKey: UserDefaults.keys.deviceToken)
        UserDefaults.standard.synchronize()
        self.deviceToken = deviceId
    }
    func getDeviceToken() -> String {
        return self.deviceToken
    }
    
    func setEmailAddress(String email:String) {
        UserDefaults.standard.set(email, forKey: UserDefaults.keys.EmailAddress)
        UserDefaults.standard.synchronize()
        self.emailAddress = email
    }
    func getEmailAddress() -> String {
        return self.emailAddress
    }
    
    func setPassword(String input:String) {
        UserDefaults.standard.set(input, forKey: UserDefaults.keys.Password)
        UserDefaults.standard.synchronize()
        self.password = input
    }
    func getPassword() -> String {
        return self.password
    }
    
    
    
    
    func resetUserData() {
        UserDefaults.standard.removeObject(forKey: UserDefaults.keys.userDefaultsKey)
        UserDefaults.standard.removeObject(forKey: UserDefaults.keys.isLoggedIn)
        UserDefaults.standard.removeObject(forKey: UserDefaults.keys.accessToken)
        UserDefaults.standard.removeObject(forKey: UserDefaults.keys.touchIDEnableStatus)
        UserDefaults.standard.removeObject(forKey: UserDefaults.keys.EmailAddress)
        UserDefaults.standard.removeObject(forKey: UserDefaults.keys.Password)
        UserDefaults.standard.synchronize()
    }
    
    
    func isEnabledTouchID() -> Bool {
        let status = UserDefaults.standard.bool(forKey: UserDefaults.keys.touchIDEnableStatus)
        return status;
    }
    func setTouchIDEnableStatus( status: Bool) {
        UserDefaults.standard.set(status, forKey: UserDefaults.keys.touchIDEnableStatus)
    }
    
}
