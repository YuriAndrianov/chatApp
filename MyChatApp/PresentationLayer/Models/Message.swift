//
//  Message.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 07.03.2022.
//

import Foundation
import FirebaseFirestore

struct Message {
    
    var content: String
    var created: Date
    var senderId: String
    var senderName: String
    
}

extension Message {
    
    var toDict: [String: Any] {
        return [
            "content": content as Any,
            "created": Timestamp(date: created),
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
        return lhs.created < rhs.created
    }
    
}

// MARK: - Custom init

extension Message {
    
    init?(dbMessage: DBMessage) {
        guard let senderId = dbMessage.senderId,
        let content = dbMessage.content,
        let created = dbMessage.created,
              let senderName = dbMessage.senderName else { return nil }
        
        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
    }
    
    init?(from data: [String: Any]) {
        guard let senderId = data["senderId"] as? String,
        let content = data["content"] as? String,
        let created = data["created"] as? Timestamp,
              let senderName = data["senderName"] as? String else { return nil }
        
        self.content = content
        self.created = created.dateValue()
        self.senderId = senderId
        self.senderName = senderName
    }
    
}
