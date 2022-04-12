//
//  Channel.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 27.03.2022.
//

import Foundation
import FirebaseFirestore

struct Channel {
    
    let identifier: String?
    let name: String?
    let lastMessage: String?
    let lastActivity: Date?
    
}

extension Channel {
    
    var toDict: [String: Any] {
        return ["identifier": identifier as Any,
                "name": name as Any,
                "lastMessage": lastMessage as Any,
                "lastActivity": lastActivity as Any]
    }
    
}

extension Channel: Comparable {
    
    static func == (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    static func < (lhs: Channel, rhs: Channel) -> Bool {
        guard let leftName = lhs.name,
              let rightName = rhs.name else { return false }
        return leftName < rightName
    }
    
}

// MARK: - Custom init

extension Channel {
    
    init(dbChannel: DBChannel) {
        self.identifier = dbChannel.identifier
        self.name = dbChannel.name
        self.lastMessage = dbChannel.lastMessage
        self.lastActivity = dbChannel.lastActivity
    }
    
    init?(from document: QueryDocumentSnapshot) {
        let data = document.data()
        
        let identifier = document.documentID
        let name = data["name"] as? String
        let lastMessage = data["lastMessage"] as? String
        let lastActivity = data["lastActivity"] as? Timestamp

        self.identifier = identifier
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity?.dateValue()
    }
    
}
