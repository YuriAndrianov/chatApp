//
//  CoreDataManager.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 04.04.2022.
//

import CoreData

protocol ChannelFetchable {
    
    func fetchChannels() -> [DBChannel]
    
    func fetchChannelWithPredicate(channel: Channel) -> DBChannel?
    
}

protocol MessageFetchable {
    
    func fetchMessages() -> [DBMessage]
    
    func fetchMessageWithPredicate(message: Message) -> DBMessage?
    
}

protocol CoreDataManager: ChannelFetchable, MessageFetchable {

    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void)
    
    func deleteObject(_ object: NSManagedObject)
    
    func refreshObject(_ object: NSManagedObject)
    
}
