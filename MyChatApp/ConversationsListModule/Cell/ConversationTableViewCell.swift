//
//  ConversationTableViewCell.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 07.03.2022.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    
    static let identifier = "chatCell"
    
    @IBOutlet weak var friendPhotoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    func configurate(with conversation: Conversation) {
        self.name = conversation.name
        self.date = conversation.date
        self.message = conversation.lastMessageText
        self.online = conversation.online
        self.hasUnreadMessages = conversation.hasUnreadMessages
    }
    
}

extension ConversationTableViewCell: ConversationCellConfiguration {
    var name: String? {
        get {
            return nil
        }
        set {
            nameLabel.text = newValue
        }
    }
    
    var message: String? {
        get {
            return nil
        }
        set {
            if newValue == nil {
                messageLabel.text = "No messages yet"
                messageLabel.textColor = .secondaryLabel
            } else {
                messageLabel.text = newValue
                messageLabel.textColor = .label
            }
        }
    }
    
    var date: Date? {
        get {
            return nil
        }
        set {
            dateLabel.text = newValue?.lastMessageDateFormat()
        }
    }
    
    var online: Bool {
        get {
            return false
        }
        set {
            if newValue {
                self.contentView.backgroundColor = UIColor(named: "onlineColor")
            } else {
                self.contentView.backgroundColor = .systemBackground
            }
        }
    }
    
    var hasUnreadMessages: Bool {
        get {
            return false
        }
        set {
            if newValue {
                messageLabel.font = .boldSystemFont(ofSize: 15)
            } else {
                messageLabel.font = .systemFont(ofSize: 13)
            }
        }
    }
    
    
    
    
}
