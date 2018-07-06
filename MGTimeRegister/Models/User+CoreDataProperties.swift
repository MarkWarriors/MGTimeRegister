//
//  User+CoreDataProperties.swift
//  
//
//  Created by Marco Guerrieri on 06/07/18.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var username: String?
    @NSManaged public var password: String
    @NSManaged public var companies: NSSet?

}

// MARK: Generated accessors for companies
extension User {

    @objc(addCompaniesObject:)
    @NSManaged public func addToCompanies(_ value: Company)

    @objc(removeCompaniesObject:)
    @NSManaged public func removeFromCompanies(_ value: Company)

    @objc(addCompanies:)
    @NSManaged public func addToCompanies(_ values: NSSet)

    @objc(removeCompanies:)
    @NSManaged public func removeFromCompanies(_ values: NSSet)

}
