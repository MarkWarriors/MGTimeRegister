//
//  Project+CoreDataProperties.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//
//

import Foundation
import CoreData


extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var name: String?
    @NSManaged public var company: Company?
    @NSManaged public var times: NSSet?

}

// MARK: Generated accessors for tasks
extension Project {

    @objc(addTimesObject:)
    @NSManaged public func addToTimes(_ value: Time)

    @objc(removeTimesObject:)
    @NSManaged public func removeFromTimes(_ value: Time)

    @objc(addTimes:)
    @NSManaged public func addToTimes(_ values: NSSet)

    @objc(removeTimes:)
    @NSManaged public func removeFromTimes(_ values: NSSet)

}

extension Project {
    public func totalHoursCount() -> Int {
        // TODO
//        return self.times?.reduce(0, { $0 + Int(($1 as! Time).hours) }) ?? 0
        return 0
    }
}

