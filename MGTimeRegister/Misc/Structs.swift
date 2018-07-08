//
//  Structs.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 05/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import Foundation
import RxDataSources


struct ProjectHours {
    var project: Project
    var totalHours: Int32
}

struct CompanyHours {
    var company: Company
    var totalHours: Int32
}

struct DateHours {
    var date: String
    var totalHours: Int32
}


struct MainReportData {
    var header: CompanyHours
    var items: [ProjectHours]
}

extension MainReportData: SectionModelType {
    init(original: MainReportData, items: [ProjectHours]) {
        self = original
        self.items = items
    }
}

struct TimeReportData {
    var header: DateHours
    var items: [Time]
}

extension TimeReportData: SectionModelType {
    init(original: TimeReportData, items: [Time]) {
        self = original
        self.items = items
    }
}

public class MGTViewModelSegue {
    var identifier : String
    var flag : String?
    
    init(identifier: String, flag: String? = nil) {
        self.identifier = identifier
        self.flag = flag
    }
}

struct MGTError {
    var title : String
    var description : String
    var code : Int
    
    init(title: String, description: String, code: Int = 999) {
        self.title = title
        self.description = description
        self.code = code
    }
}

struct MGTConfirm {
    var title : String
    var message : String
    var callback : ((Bool)->())?
    
    init(title: String, message: String, callback: ((Bool)->())?) {
        self.title = title
        self.message = message
        self.callback = callback
    }
}
