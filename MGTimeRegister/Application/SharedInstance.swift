//
//  SharedInstance.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import Foundation

public class SharedInstance : NSObject {
    
    public static let shared = SharedInstance()
    
    public private(set) var currentUser : User?
    
    public func storeCredentials(username: String, password: String){
        UserDefaults.standard.set(username, forKey: Globals.PrefsKeys.loggedUsername)
        UserDefaults.standard.set(password, forKey: Globals.PrefsKeys.loggedPassword)
        UserDefaults.standard.synchronize()
    }
    
    public func getStoredCredentials() -> (username: String, password: String)? {
        if let username = UserDefaults.standard.value(forKey: Globals.PrefsKeys.loggedUsername) as? String,
            let password = UserDefaults.standard.value(forKey: Globals.PrefsKeys.loggedPassword) as? String {
            return (username, password)
        }
        return nil
    }
    
    public func loginUser(_ user: User){
        self.currentUser = user
    }
    
    public func logout(){
        self.currentUser = nil
        UserDefaults.standard.removeObject(forKey: Globals.PrefsKeys.loggedUsername)
        UserDefaults.standard.removeObject(forKey: Globals.PrefsKeys.loggedPassword)
    }
    
}
