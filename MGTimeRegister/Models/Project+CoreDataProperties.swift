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

    @objc(addTimeObject:)
    @NSManaged public func addToTime(_ value: Time)

    @objc(removeTimeObject:)
    @NSManaged public func removeFromTime(_ value: Time)

    @objc(addTime:)
    @NSManaged public func addToTime(_ values: NSSet)

    @objc(removeTime:)
    @NSManaged public func removeFromTime(_ values: NSSet)

}

extension Project {
    public func totalHoursCount() -> Int {
        return self.times != nil ? self.times!.reduce(0, { $0 + Int(($1 as! Time).hours) }) : 0
    }
}
