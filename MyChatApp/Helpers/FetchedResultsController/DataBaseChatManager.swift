//
//  FetchedResultsController.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 14.04.2022.
//

import Foundation
import CoreData

protocol ChatObjectsFetchable {
    
    var coreDataStack: CoreDataStackProtocol { get set }
    
    var channelsFetchedResultsController: NSFetchedResultsController<DBChannel>? { get set }
    
    var messagesFetchedResultsController: NSFetchedResultsController<DBMessage>? { get set }
    
    func fetchChannels(with predicate: NSPredicate?)
    
    func fetchMessages(with predicate: NSPredicate?)

}

class DataBaseChatManager: ChatObjectsFetchable {
    
    var coreDataStack: CoreDataStackProtocol
    
    var channelsFetchedResultsController: NSFetchedResultsController<DBChannel>?
    
    var messagesFetchedResultsController: NSFetchedResultsController<DBMessage>?
    
    init(coreDataStack: CoreDataStackProtocol) {
        self.coreDataStack = coreDataStack
    }
    
    func fetchChannels(with predicate: NSPredicate?) {
        let context = coreDataStack.readContext
        
        let fetchRequest = DBChannel.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastActivity", ascending: false)]
        fetchRequest.predicate = predicate
        
        channelsFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        do {
            try channelsFetchedResultsController?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchMessages(with predicate: NSPredicate?) {
        let context = coreDataStack.readContext
        
        let fetchRequest = DBMessage.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
        fetchRequest.predicate = predicate
        
        messagesFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        do {
            try messagesFetchedResultsController?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
