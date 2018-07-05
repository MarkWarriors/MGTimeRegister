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
        struct Reports {
            public static let pickDate = "toPickDate"
            public static let toReportTimeList = "toReportTimeList"
            public static let toTimeDetails = "toTimeDetails"
        }
        
        struct AddTimeEntry {
            public static let newCompany = "toNewCompany"
            public static let newProject = "toNewProject"
            public static let newTimeEntry = "toNewTimeEntry"
            
            public static let selectCompany = "toPickCompany"
            public static let selectProject = "toPickProject"
            
            public static let unwindToTabBar = "unwindToTabBar"
        }
    }
    
}
