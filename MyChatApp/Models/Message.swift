//
//  Message.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 07.03.2022.
//

import Foundation
import FirebaseFirestore

struct Message {
    
    var content: String?
    var created: Date?
    var senderId: String?
    var senderName: String?
    
}

extension Message {
    
    var toDict: [String: Any] {
        return [
            "content": content as Any,
            "created": Timestamp(date: created ?? Date()),
            "senderId": senderId as Any,
            "senderName": senderName as Any
        ]
    }
    
}

extension Message: Comparable {
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.senderId == rhs.senderId
    }
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        guard let leftDate = lhs.created,
              let rightDate = rhs.created else { return false }
        return leftDate < rightDate
    }
    
}

// MARK: - Custom init

extension Message {
    
    init?(dbMessage: DBMessage) {
        self.content = dbMessage.content
        self.created = dbMessage.created
        self.senderId = dbMessage.senderId
        self.senderName = dbMessage.senderName
    }
    
    init?(from data: [String: Any]) {
        let senderId = data["senderId"] as? String
        let content = data["content"] as? String
        let created = data["created"] as? Timestamp
        let senderName = data["senderName"] as? String
        
        self.content = content
        self.created = created?.dateValue()
        self.senderId = senderId
        self.senderName = senderName
    }
    
}
