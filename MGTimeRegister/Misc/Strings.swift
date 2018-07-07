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
        public static let createUserTitle = "Login.createUserTitle".localized
        public static func createUserMessage(username: String) -> String {
            return String(format: "Login.createUserMessage(username:)".localized , username)
        }
    }
    
    struct Logout {
        public static let logoutUserTitle = "Logout.logoutTitle".localized
        public static let logoutUserText = "Logout.logoutMessage".localized
    }
    
    struct Commons {
        public static let yes = "Commons.yes".localized
        public static let no = "Commons.no".localized
        public static let ok = "Commons.ok".localized
        public static let confirm = "Commons.confirm".localized
        public static let cancel = "Commons.cancel".localized
        public static let delete = "Commons.delete".localized
        public static let select = "Commons.select".localized
    }
    
    struct Errors {
        public static let error = "Errors.error".localized
        public static let invalidCredentials = "Errors.invalidCredentials".localized
        public static let incompleteForm = "Errors.incompleteForm".localized
        public static let genericErrorOccurred = "Errors.errorOccurred".localized
    }
}
