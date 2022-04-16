//
//  CoreDataStack.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 14.04.2022.
//

import Foundation
import CoreData

protocol CoreDataStackProtocol {
    
    var context: NSManagedObjectContext { get }
    func saveObject(_ object: NSManagedObject)
    func deleteObject(_ object: NSManagedObject)
    func refreshObject(_ object: NSManagedObject)
    
}
