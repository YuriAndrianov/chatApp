//
//  Channel.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 27.03.2022.
//

import Foundation
import FirebaseFirestore

struct Channel {
    
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
    
}

extension Channel {
    
    var toDict: [String: Any] {
        return ["identifier": identifier,
                "name": name,
                "lastMessage": lastMessage as Any,
                "lastActivity": lastActivity as Any]
    }
    
}

extension Channel: Comparable {
    
    static func == (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    static func < (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.name < rhs.name
    }
    
}
