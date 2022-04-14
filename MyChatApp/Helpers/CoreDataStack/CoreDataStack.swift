//
//  CoreDataStack.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 14.04.2022.
//

import Foundation
import CoreData

protocol CoreDataStackProtocol {
    
    var readContext: NSManagedObjectContext { get }
    var writeContext: NSManagedObjectContext { get }
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void)
    func deleteObject(_ object: NSManagedObject)
    func refreshObject(_ object: NSManagedObject)
    
}
