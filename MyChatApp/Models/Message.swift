//
//  Message.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 07.03.2022.
//

import Foundation

struct Message {

    var content: String
    var created: Date
    var senderId: String
    var senderName: String
    
}

extension Message: Comparable {
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.senderId == rhs.senderId
    }
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.created < rhs.created
    }
    
}
