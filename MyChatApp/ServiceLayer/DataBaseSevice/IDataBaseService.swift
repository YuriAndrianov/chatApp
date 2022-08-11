//
//  DataBaseService.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 17.04.2022.
//

import CoreData

protocol IDataBaseService {
    
    var context: NSManagedObjectContext { get }
    var messagePredicate: NSPredicate? { get set }
    var channelsFetchedResultsController: NSFetchedResultsController<DBChannel> { get set }
    var messagesFetchedResultsController: NSFetchedResultsController<DBMessage> { get set }
    
    func setPredicate(with channel: Channel)
    func saveChannel(_ channel: Channel)
    func updateChannel(_ channel: Channel)
    func deleteChannel(_ channel: Channel)
    func addMessage(_ message: Message, to channel: Channel)
    func updateMessage(_ message: Message)
    func deleteMessage(_ message: Message)
    
}
