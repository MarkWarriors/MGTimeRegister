//
//  Project+CoreDataProperties.swift
//  
//
//  Created by Marco Guerrieri on 03/07/18.
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

// MARK: Generated accessors for time
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
        return self.times != nil ? self.times!.reduce(0, { $0 + Int(($1 as! Time).hours) }) : 0
    }
}
