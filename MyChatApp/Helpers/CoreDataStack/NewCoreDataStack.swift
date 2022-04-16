//
//  NewCoreDataStack.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 14.04.2022.
//

import Foundation
import CoreData

class NewCoreDataStack: CoreDataStackProtocol {
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyChatApp")
        container.loadPersistentStores { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        return container
    }()
    
    func saveObject(_ object: NSManagedObject) {
        guard let context = object.managedObjectContext else { return }
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteObject(_ object: NSManagedObject) {
        context.delete(object)
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func refreshObject(_ object: NSManagedObject) {
        context.refresh(object, mergeChanges: true)
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
