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
    
    struct Commons {
        public static let ok = "Ok".localized
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
