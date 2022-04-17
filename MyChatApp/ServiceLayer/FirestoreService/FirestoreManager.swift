//
//  FirestoreManager.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 06.04.2022.
//

import FirebaseFirestore

final class FirestoreManager {
    
    var channel: Channel?
    
    private lazy var db = Firestore.firestore()
    private lazy var channelsCollectionReference = db.collection("channels")
    private lazy var messagesCollectionReference: CollectionReference? = {
        guard let id = channel?.identifier else { return nil }
        return channelsCollectionReference.document(id).collection("messages")
    }()
   
    enum ObjectType {
        case channels
        case messages
    }
    
    func fetch(_ objects: ObjectType, completion: @escaping (QuerySnapshot?) -> Void) {
        var reference: CollectionReference?
        
        switch objects {
        case .channels:
            reference = channelsCollectionReference
        case .messages:
            reference = messagesCollectionReference
        }
        
        reference?.addSnapshotListener { snapshot, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                completion(nil)
                return
            }
            completion(snapshot)
        }
    }
    
    func addDocument(_ objects: ObjectType, data: [String: Any]) {
        var reference: CollectionReference?
        
        switch objects {
        case .channels:
            reference = channelsCollectionReference
        case .messages:
            reference = messagesCollectionReference
        }
        
        reference?.addDocument(data: data)
    }
    
    func deleteObject(with id: String) {
        channelsCollectionReference.document(id).delete()
    }
    
}
