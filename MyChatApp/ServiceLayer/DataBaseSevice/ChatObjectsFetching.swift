//
//  ChatObjectsFetching.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 17.04.2022.
//

import CoreData

protocol ChatObjectsFetching {
    
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
