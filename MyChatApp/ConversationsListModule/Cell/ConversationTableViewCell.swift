//
//  ConversationTableViewCell.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 07.03.2022.
//

import UIKit

final class ConversationTableViewCell: UITableViewCell {
    
    static let identifier = "chatCell"
    static let nib = UINib(nibName: "ConversationTableViewCell", bundle: .main)
    
    @IBOutlet weak var friendPhotoImageView: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var messageLabel: UILabel?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0))
        nameLabel?.textColor = ThemePicker.currentTheme?.fontColor
        dateLabel?.textColor = ThemePicker.currentTheme?.fontColor
        friendPhotoImageView?.tintColor = ThemePicker.currentTheme?.barButtonColor
        backgroundColor = ThemePicker.currentTheme?.backGroundColor
    }
   

    func configurate(with conversation: Conversation) {
        self.name = conversation.name
        self.date = conversation.date
        self.message = conversation.lastMessageText
        self.online = conversation.online
        self.hasUnreadMessages = conversation.hasUnreadMessages
    }
    
    private func setupViewWithMessage(_ message: String?) {
        if message == nil {
            messageLabel?.text = "No messages yet"
            messageLabel?.textColor = ThemePicker.currentTheme?.barButtonColor
        } else {
            messageLabel?.text = message
            messageLabel?.textColor = ThemePicker.currentTheme?.fontColor
        }
    }
    
}

extension ConversationTableViewCell: ConversationCellConfiguration {
    var name: String? {
        get { return nil }
        set { nameLabel?.text = newValue }
    }
    
    var message: String? {
        get { return nil }
        set { setupViewWithMessage(newValue) }
    }
    
    var date: Date? {
        get { return nil }
        set { dateLabel?.text = newValue?.lastMessageDateFormat() }
    }
    
    var online: Bool {
        get { return false }
        set { contentView.backgroundColor = newValue ? ThemePicker.currentTheme?.outcomingMessageColor : ThemePicker.currentTheme?.backGroundColor }
    }
    
    var hasUnreadMessages: Bool {
        get { return false }
        set { messageLabel?.font = newValue ? .boldSystemFont(ofSize: 15) : .systemFont(ofSize: 13) }
    }
    
}
