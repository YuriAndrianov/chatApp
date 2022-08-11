//
//  IFirestoreService.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 17.04.2022.
//

import FirebaseFirestore

protocol IFirestoreService: AnyObject {
    
    var db: Firestore { get }
    var channelsCollectionReference: CollectionReference { get }
    var messagesCollectionReference: CollectionReference? { get }
    
    func fetch(_ objects: ObjectType, completion: @escaping (QuerySnapshot?) -> Void)
    func addDocument(_ objects: ObjectType, data: [String: Any])
    func deleteObject(with id: String)
}

enum ObjectType {
    
    case channels
    case messages
}
