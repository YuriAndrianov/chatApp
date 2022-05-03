//
//  NewCoreDataManager.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 03.04.2022.
//

import CoreData

final class NewCoreDataManager: CoreDataManager {
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyChatApp")
        container.loadPersistentStores { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        return container
    }()
    
    func fetchChannels(predicate: NSPredicate?) -> [DBChannel] {
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        
        if let predicate = predicate { fetchRequest.predicate = predicate }
        
        do {
            return try container.viewContext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchMessages(predicate: NSPredicate) -> [DBMessage] {
        let fetchRequest: NSFetchRequest<DBMessage> = DBMessage.fetchRequest()
        fetchRequest.predicate = predicate
        do {
            return try container.viewContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
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
