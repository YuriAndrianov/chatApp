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
        return ["content": content,
                "created": Timestamp(date: created),
                "senderID": senderId,
                "senderName": senderName]
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
    
    init(dbMessage: DBMessage) {
        self.content = dbMessage.content ?? ""
        self.created = dbMessage.created ?? Date()
        self.senderId = dbMessage.senderId ?? ""
        self.senderName = dbMessage.senderName ?? ""
    }
    
}
