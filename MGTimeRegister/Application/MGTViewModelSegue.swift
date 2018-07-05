//
//  MGTViewModelSegue.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import Foundation

public class MGTViewModelSegue {
    var identifier : String
    var flag : String?
    
    init(identifier: String, flag: String? = nil) {
        self.identifier = identifier
        self.flag = flag
    }
}
