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
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print(storeDescription)
            }
        }
        return container
    }()
    
    func fetchChannels() -> [DBChannel] {
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        
        do {
            return try container.viewContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchMessages() -> [DBMessage] {
        let fetchRequest: NSFetchRequest<DBMessage> = DBMessage.fetchRequest()
        
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
    
}
