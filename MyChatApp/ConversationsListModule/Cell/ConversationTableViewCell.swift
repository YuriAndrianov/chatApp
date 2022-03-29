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
    
    private var currentTheme: ThemeProtocol? {
        return ThemePicker.shared.currentTheme
    }
    
    @IBOutlet weak var friendPhotoImageView: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var messageLabel: UILabel?
   
    func configurate(with channel: Channel) {
        nameLabel?.text = channel.name
        dateLabel?.text = channel.lastActivity?.lastMessageDateFormat()
        setupViewWithMessage(channel.lastMessage)
    }
    
    private func setupViewWithMessage(_ message: String?) {
        if message == nil {
            messageLabel?.text = "No messages yet"
            messageLabel?.textColor = currentTheme?.barButtonColor
        } else {
            messageLabel?.text = message
            messageLabel?.textColor = currentTheme?.fontColor
        }
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0))
        nameLabel?.textColor = currentTheme?.fontColor
        dateLabel?.textColor = currentTheme?.fontColor
        friendPhotoImageView?.tintColor = currentTheme?.barButtonColor
        backgroundColor = currentTheme?.backgroundColor
    }
    
}
