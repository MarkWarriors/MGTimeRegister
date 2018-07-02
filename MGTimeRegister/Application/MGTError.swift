//
//  MGTError.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import Foundation

public class MGTError {
    var title : String
    var description : String
    var code : Int
    
    init(title: String, description: String, code: Int = 999) {
        self.title = title
        self.description = description
        self.code = code
    }
}
