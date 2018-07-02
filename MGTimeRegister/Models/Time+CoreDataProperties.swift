//
//  Time+CoreDataProperties.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//
//

import Foundation
import CoreData


extension Time {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Time> {
        return NSFetchRequest<Time>(entityName: "Time")
    }

    @NSManaged public var notes: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var time: Int16
    @NSManaged public var task: Task?

}
