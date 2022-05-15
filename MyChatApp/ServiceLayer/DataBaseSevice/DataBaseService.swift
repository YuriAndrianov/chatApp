//
//  DataBaseChatManager.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 14.04.2022.
//

import Foundation
import CoreData

final class DataBaseService: IDataBaseService {
    
    var messagePredicate: NSPredicate?
    
    var context: NSManagedObjectContext {
        return coreDataStack.context
    }
    
    private var coreDataStack: CoreDataStackProtocol
    
    lazy var channelsFetchedResultsController: NSFetchedResultsController<DBChannel> = {
        let fetchRequest = DBChannel.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastActivity", ascending: false)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        do {
            try controller.performFetch()
        } catch {
            print(error.localizedDescription)
        }

        return controller
    }()
    
    lazy var messagesFetchedResultsController: NSFetchedResultsController<DBMessage> = {
        let fetchRequest = DBMessage.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
        fetchRequest.predicate = messagePredicate
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        do {
            try controller.performFetch()
        } catch {
            print(error.localizedDescription)
        }

        return controller
    }()
    
    init(coreDataStack: CoreDataStackProtocol) {
        self.coreDataStack = coreDataStack
    }
    
    func setPredicate(with channel: Channel) {
        messagePredicate = NSPredicate(format: "channel.identifier == %@", channel.identifier)
    }
    
    func saveChannel(_ channel: Channel) {
        // checking uniqueness
        let id = channel.identifier
        let predicate = NSPredicate(format: "identifier == %@", id)
        
        guard fetchChannel(with: predicate) == nil else { return }
        
        let dbChannel = DBChannel(context: context)
        dbChannel.identifier = channel.identifier
        dbChannel.name = channel.name
        dbChannel.lastMessage = channel.lastMessage
        dbChannel.lastActivity = channel.lastActivity
        
        saveObject(dbChannel)
        print("Channel \"\(dbChannel.name ?? "")\" saved to DB")
    }
    
    func updateChannel(_ channel: Channel) {
        let id = channel.identifier
        let predicate = NSPredicate(format: "identifier == %@", id)
        
        guard let dbChannel = fetchChannel(with: predicate) else { return }
        dbChannel.name = channel.name
        dbChannel.lastMessage = channel.lastMessage
        dbChannel.lastActivity = channel.lastActivity
        refreshObject(dbChannel)
        print("Channel \"\(dbChannel.name ?? "")\" updated in DB")
    }
    
    func deleteChannel(_ channel: Channel) {
        let id = channel.identifier
        let predicate = NSPredicate(format: "identifier == %@", id)
        
        guard let dbChannel = fetchChannel(with: predicate) else { return }
        deleteObject(dbChannel)
        print("Channel \"\(dbChannel.name ?? "")\" deleted from DB")
    }
    
    func addMessage(_ message: Message, to channel: Channel) {
        // checking uniqueness
        let predicate = NSPredicate(format: "senderId == %@ && created == %@",
                                    message.senderId,
                                    message.created as CVarArg)
        guard fetchMessage(with: predicate) == nil else { return }
        
        let dbMessage = DBMessage(context: context)
        dbMessage.content = message.content
        dbMessage.senderName = message.senderName
        dbMessage.created = message.created
        dbMessage.senderId = message.senderId
        
        guard let dbChannel = fetchChannel(with: NSPredicate(format: "identifier == %@",
                                                                             channel.identifier)) else { return }
        dbChannel.addToMessages(dbMessage)
        saveObject(dbChannel)
        print("Message: \"\(String(describing: message.content))\" saved to DB")
    }
    
    func updateMessage(_ message: Message) {
        let predicate = NSPredicate(format: "senderId == %@ && created == %@",
                                    message.senderId,
                                    message.created as CVarArg)
        guard let dbMessage = fetchMessage(with: predicate) else { return }
        dbMessage.content = message.content
        dbMessage.senderName = message.senderName
        
        refreshObject(dbMessage)
        print("Message from \"\(String(describing: message.created))\" updated in DB")
    }
    
    func deleteMessage(_ message: Message) {
        let predicate = NSPredicate(format: "senderId == %@ && created == %@",
                                    message.senderId,
                                    message.created as CVarArg)
        guard let dbMessage = fetchMessage(with: predicate) else { return }
        
        deleteObject(dbMessage)
        print("Message from\"\(String(describing: message.created))\" deleted from DB")
    }
    
    private func fetchChannel(with predicate: NSPredicate) -> DBChannel? {
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            return try context.fetch(fetchRequest).first
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func fetchMessage(with predicate: NSPredicate) -> DBMessage? {
        let fetchRequest: NSFetchRequest<DBMessage> = DBMessage.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            return try context.fetch(fetchRequest).first
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func saveObject(_ object: NSManagedObject) {
        coreDataStack.saveObject(object)
    }
    
    private func refreshObject(_ object: NSManagedObject) {
        coreDataStack.refreshObject(object)
    }
    
    private func deleteObject(_ object: NSManagedObject) {
        coreDataStack.deleteObject(object)
    }
    
}
