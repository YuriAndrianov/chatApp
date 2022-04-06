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
    
    func fetchChannelWithPredicate(channel: Channel) -> DBChannel? {
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        
        guard let id = channel.identifier else { return nil }
        
        let predicate = NSPredicate(format: "identifier == %@", id)
        fetchRequest.predicate = predicate
        
        do {
            return try container.viewContext.fetch(fetchRequest).first
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fetchMessageWithPredicate(message: Message) -> DBMessage? {
        let fetchRequest: NSFetchRequest<DBMessage> = DBMessage.fetchRequest()
        
        guard let senderId = message.senderId,
              let created = message.created else { return nil }
        
        let predicate = NSPredicate(format: "senderId == %@ && created == %@", senderId, created as CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            return try container.viewContext.fetch(fetchRequest).first
        } catch let error {
            print(error.localizedDescription)
            return nil
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
