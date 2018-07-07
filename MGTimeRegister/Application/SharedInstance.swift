//
//  SharedInstance.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit

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
    
    public func loginUser(_ user: User, storeCredential: Bool){
        self.currentUser = user
        if storeCredential {
            self.storeCredentials(username: user.username!, password: user.password)
        }
    }
    
    public func logout(){
        let loginVC = UIStoryboard.init(name: "Login", bundle: nil).instantiateInitialViewController()
        loginVC?.view.frame = CGRect.init(x: 0, y: -UIScreen.main.bounds.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        UIView.transition(with: UIApplication.shared.keyWindow!,
                          duration: 0.5, options: UIViewAnimationOptions.curveEaseInOut,
                          animations: {
                            UIApplication.shared.keyWindow!.rootViewController = loginVC
                            loginVC?.view.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }) { (complete) in
            self.currentUser = nil
            UserDefaults.standard.removeObject(forKey: Globals.PrefsKeys.loggedUsername)
            UserDefaults.standard.removeObject(forKey: Globals.PrefsKeys.loggedPassword)
        }
        
        
    }
    
}
