//
//  Conversation.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 07.03.2022.
//

import Foundation

struct Conversation {
    
    var name: String?
    var lastMessageText: String? {
        guard let messages = messages else { return nil }
        guard let lastMessage = messages.sorted(by: {
            if let lastDate = $0.date,
               let firstDate = $1.date {
                return lastDate > firstDate
            } else { return false }
        }).first else { return nil }
        return lastMessage.text
    }
    var date: Date? {
        guard let messages = messages else { return nil }
        guard let lastMessage = messages.sorted(by: {
            if let lastDate = $0.date,
               let firstDate = $1.date {
                return lastDate > firstDate
            } else { return false }
        }).first else { return nil }
        return lastMessage.date
    }
    var online: Bool
    var hasUnreadMessages: Bool {
        guard let messages = messages else { return false }
        let unreadMessages = messages.filter{$0.isIncoming && $0.unread}
        
        if unreadMessages.isEmpty {
            return false
        } else { return true }
    }
    
    var messages: [Message]?
    
}
