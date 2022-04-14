//
//  NewCoreDataStack.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 14.04.2022.
//

import Foundation
import CoreData

class NewCoreDataStack: CoreDataStackProtocol {
    
    var readContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    var writeContext: NSManagedObjectContext {
        return container.newBackgroundContext()
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
    
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = container.newBackgroundContext()
        context.perform {
            block(context)
            
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func deleteObject(_ object: NSManagedObject) {
        guard let context = object.managedObjectContext else { return }
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
        guard let context = object.managedObjectContext else { return }
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
