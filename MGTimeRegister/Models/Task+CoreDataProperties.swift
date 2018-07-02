//
//  Task+CoreDataProperties.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var project: Project?
    @NSManaged public var times: NSSet?

}

// MARK: Generated accessors for times
extension Task {

    @objc(addTimesObject:)
    @NSManaged public func addToTimes(_ value: Time)

    @objc(removeTimesObject:)
    @NSManaged public func removeFromTimes(_ value: Time)

    @objc(addTimes:)
    @NSManaged public func addToTimes(_ values: NSSet)

    @objc(removeTimes:)
    @NSManaged public func removeFromTimes(_ values: NSSet)

}
