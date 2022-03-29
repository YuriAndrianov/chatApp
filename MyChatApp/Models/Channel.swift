//
//  Channel.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 27.03.2022.
//

import Foundation

struct Channel {
    
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
    
}

extension Channel: Comparable {
    
    static func == (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    static func < (lhs: Channel, rhs: Channel) -> Bool {
        if let lhsDate = lhs.lastActivity,
           let rhsDate = rhs.lastActivity {
            return lhsDate < rhsDate
        } else {
            return lhs.name < rhs.name
        }
    }
    
}
