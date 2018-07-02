//
//  Segues.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import Foundation

public class Segues {
    
    struct Login {
        public static let toHome = "toHome"
    }
    
    struct Home {
        struct AddTime {
            public static let newCompany = "toNewCompany"
            public static let newProject = "toNewProject"
            public static let newTask = "toNewTask"
            
            public static let pickCompany = "toPickCompany"
            public static let pickProject = "toPickProject"
            public static let pickTask = "toPickTask"
        }
    }
    
}
