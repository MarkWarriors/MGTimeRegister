//
//  Time+CoreDataProperties.swift
//  
//
//  Created by Marco Guerrieri on 03/07/18.
//
//

import Foundation
import CoreData


extension Time {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Time> {
        return NSFetchRequest<Time>(entityName: "Time")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var hours: Int16
    @NSManaged public var notes: String?
    @NSManaged public var project: Project?

}
