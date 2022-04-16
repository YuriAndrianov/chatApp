//
//  DataBaseChatManager.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 14.04.2022.
//

import Foundation
import CoreData

protocol ChatObjectsFetchable {
    
    var context: NSManagedObjectContext { get }
    
    var messagePredicate: NSPredicate? { get set }

    var channelsFetchedResultsController: NSFetchedResultsController<DBChannel> { get set }
    
    var messagesFetchedResultsController: NSFetchedResultsController<DBMessage> { get set }
    
    func fetchChannel(with predicate: NSPredicate) -> DBChannel?
    
    func fetchMessage(with predicate: NSPredicate) -> DBMessage?
    
    func saveObject(_ object: NSManagedObject)
    
    func refreshObject(_ object: NSManagedObject)
    
    func deleteObject(_ object: NSManagedObject)
    
}

class DataBaseChatManager: ChatObjectsFetchable {
    
    var messagePredicate: NSPredicate?
    
    var context: NSManagedObjectContext {
        return coreDataStack.context
    }
    
    private var coreDataStack: CoreDataStackProtocol
    
    lazy var channelsFetchedResultsController: NSFetchedResultsController<DBChannel> = {
        let context = coreDataStack.context
        
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
        let context = coreDataStack.context
        
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
    
    func fetchChannel(with predicate: NSPredicate) -> DBChannel? {
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            return try coreDataStack.context.fetch(fetchRequest).first
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fetchMessage(with predicate: NSPredicate) -> DBMessage? {
        let fetchRequest: NSFetchRequest<DBMessage> = DBMessage.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            return try coreDataStack.context.fetch(fetchRequest).first
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func saveObject(_ object: NSManagedObject) {
        coreDataStack.saveObject(object)
    }
    
    func refreshObject(_ object: NSManagedObject) {
        coreDataStack.refreshObject(object)
    }
    
    func deleteObject(_ object: NSManagedObject) {
        coreDataStack.deleteObject(object)
    }
    
}
