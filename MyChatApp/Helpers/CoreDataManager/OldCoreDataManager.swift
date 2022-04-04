//
//  OldCoreDataManager.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 03.04.2022.
//

import CoreData

final class OldCoreDataManager: CoreDataManager {
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard
            let moduleURL = Bundle.main.url(forResource: "MyChatApp", withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: moduleURL) else { return NSManagedObjectModel() }
        return model
    }()
    
    private lazy var persistentCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        let fileManager = FileManager.default
        let storeName = "MyChatApp.sqlite"
        
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let persistentStoreURL = documentsDirectory?.appendingPathComponent(storeName)
        
        do {
            try coordinator.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: persistentStoreURL
            )
        } catch let persistentError { print(persistentError.localizedDescription) }
        
        return coordinator
    }()
    
    private lazy var readContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentCoordinator
        
        return context
    }()
    
    private lazy var writeContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()
    
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = writeContext
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
    
    func fetchChannels() -> [DBChannel] {
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        
        do {
            return try readContext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchMessages() -> [DBMessage] {
        let fetchRequest: NSFetchRequest<DBMessage> = DBMessage.fetchRequest()
        
        do {
            return try readContext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
}
