//
//  ModelController.swift
//  MGTimeRegister
//
//  Created by Marco Guerrieri on 02/07/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import Foundation
import CoreData

public class ModelController : NSObject {
    static var shared = ModelController()

    var managedObjectContext: NSManagedObjectContext

    private var initialized = false

    private override init() {
        // URL of xcdatamodeld file
        guard let modelURL = Bundle.main.url(forResource: "MGTimeRegister", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // Load model
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = psc
    }

    func setup(onComlpetion completionClosure: @escaping (() -> ())) {
        DispatchQueue.global().async {
            guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                fatalError("Unable to resolve document directory")
            }
            let storeURL = docURL.appendingPathComponent("MGTimeRegister.sqlite")
            do {
                try self.managedObjectContext.persistentStoreCoordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
                
                self.initialized = true
                DispatchQueue.main.sync(execute: completionClosure)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }

    private func removeOrphanedEntity(_ entity: Entity, whereCondition: NSPredicate) {
        let orphanMOs = self.listAllElements(forEntityName: entity.rawValue, whereCondition: whereCondition)
        for orphanMO in orphanMOs {
            orphanMO.delete()
        }
    }

    func save() {
        if initialized {
            managedObjectContext.performAndWait {
                do {
                    try ModelController.shared.managedObjectContext.save()
                } catch {
                    print("DATABASE SAVE ERROR")
                }
            }
        }
    }

    func debug() {
        for entityName in Entity.all {
            let entities = self.listAllElements(forEntityName: entityName.rawValue)
            for entity in entities {
                print("CURRENTLY ON CORE DATA \(entityName.rawValue): \(entity)")
            }
        }
    }


    func new<T: NSManagedObject>(forEntity entity: Entity) -> T {
        let elem = NSEntityDescription.insertNewObject(forEntityName: entity.rawValue, into: managedObjectContext)
        return elem as! T
    }

    func temp<T: NSManagedObject>(forEntity entity: Entity) -> T {
        let ent = NSEntityDescription.entity(forEntityName: entity.rawValue, in: managedObjectContext)
        return NSManagedObject.init(entity: ent!, insertInto: nil) as! T
    }

    func listAllElements<T: NSManagedObject>(forEntityName entityName: String) -> [T] {
        let query = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let elements = try? ModelController.shared.managedObjectContext.fetch(query)
        return elements as? [T] ?? [T]()
    }

    func listAllElements<T: NSManagedObject>(forEntityName entityName: String, whereCondition: NSPredicate) -> [T] {
        let query = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        query.predicate = whereCondition
        let elements = try? ModelController.shared.managedObjectContext.fetch(query)
        return elements as? [T] ?? [T]()
    }

    func deleteAll() {
        for entityName in Entity.all {
            let entities = self.listAllElements(forEntityName: entityName.rawValue)
            for entity in entities {
                entity.delete()
            }
        }
    }
}

extension NSManagedObject {
    @objc dynamic func delete() {
        ModelController.shared.managedObjectContext.delete(self)
    }
}

    // Entities enumerator
extension ModelController {
    enum Entity: String {
        case user = "User" // Abstract
        case company = "Company"
        case project = "Project"
        case task = "Task"
        case time = "Time"
        
        static var all: [Entity] = [.user, .company, .project, .task, .time]

        
        var entityClass: NSManagedObject.Type {
            switch self {
            case .user:
                return User.self
            case .company:
                return Company.self
            case .project:
                return Project.self
            case .task:
                return Task.self
            case .time:
                return Time.self
            }
        }
    }
}

