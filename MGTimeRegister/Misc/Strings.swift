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
    
    /*
        struct Errors {
            public static let noInternetConnection = "No internet connection available".localized
            public static let genericError = "An error occurred".localized
        }
    */
}