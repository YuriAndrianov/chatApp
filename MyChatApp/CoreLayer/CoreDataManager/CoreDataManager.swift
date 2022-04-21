//
//  CoreDataManager.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 04.04.2022.
//

import CoreData

protocol CoreDataManager {
    
    func fetchChannels(predicate: NSPredicate?) -> [DBChannel]
    
    func fetchMessages(predicate: NSPredicate) -> [DBMessage]
    
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void)
    
    func deleteObject(_ object: NSManagedObject)
    
    func refreshObject(_ object: NSManagedObject)
    
}
