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

struct ReportData {
    var header: CompanyHours
    var items: [ProjectHours]
}

extension ReportData: SectionModelType {
    init(original: ReportData, items: [ProjectHours]) {
        self = original
        self.items = items
    }
}
