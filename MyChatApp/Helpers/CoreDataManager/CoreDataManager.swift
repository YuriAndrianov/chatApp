//
//  CoreDataManager.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 04.04.2022.
//

import CoreData

protocol CoreDataManager {
    
    func fetchChannels() -> [DBChannel]
    
    func fetchMessages() -> [DBMessage]
    
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void)
    
}
