//
//  MessageCellConfiguration.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 07.03.2022.
//

import Foundation

protocol MessageCellConfiguration: AnyObject {
    
    var messageText: String? { get set }
    var isIncoming: Bool { get set }
    
}
