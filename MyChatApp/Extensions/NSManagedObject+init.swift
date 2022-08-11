//
//  NSManagedObject+init.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 03.04.2022.
//

import CoreData

// Fixes bug with Multiple NSEntityDescriptions claim the NSManagedObject subclass https://github.com/drewmccormack/ensembles/issues/275

extension NSManagedObject {

    convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        guard let entity = NSEntityDescription.entity(forEntityName: name, in: context) else { fatalError() }
        self.init(entity: entity, insertInto: context)
    }
}
