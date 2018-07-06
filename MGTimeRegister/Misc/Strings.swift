//
//  Strings.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import Foundation

class Strings {
    
	public static let empty = ""
    
	static func notNullOrEmpty(_ string: String?) -> Bool{
        return string != nil && string != empty
    }
    
    struct Login {
        public static let createUserTitle = "Create user".localized
        public static func createUserMessage(username: String) -> String {
            return String(format: "The user %@ not exist, would you like to create it?", username).localized
        }
    }
    
    struct Logout {
        public static let logoutUserTitle = "Logout".localized
        public static let logoutUserText = "Are you sure you want to logout?".localized
    }
    
    struct Commons {
        public static let yes = "Yes".localized
        public static let no = "No".localized
        public static let ok = "Ok".localized
        public static let confirm = "Confirm".localized
        public static let cancel = "Cancel".localized
        public static let delete = "Delete".localized
        public static let select = "Select".localized
    }
    
    struct Errors {
        public static let error = "Error".localized
        public static let invalidCredentials = "Invalid credentials".localized
        public static let genericErrorOccurred = "An error occurred".localized
    }
}
