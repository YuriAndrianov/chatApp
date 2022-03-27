//
//  MessageTableViewCell.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 07.03.2022.
//

import UIKit

final class MessageTableViewCell: UITableViewCell {
    
    static let identifier = "messageCell"
    static let nib = UINib(nibName: "MessageTableViewCell", bundle: .main)
    
    private var currentTheme: ThemeProtocol? {
        return ThemePicker.shared.currentTheme
    }

    @IBOutlet weak var leadingConstraint: NSLayoutConstraint?
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint?
    @IBOutlet weak var messageTextLabel: UILabel?
    @IBOutlet weak var bubbleView: UIView?
    @IBOutlet weak var dateLabel: UILabel?

    func configurate(with message: Message) {
        setupViewIfIncoming(isTrue: Bool.random())
        messageTextLabel?.text = message.content
        dateLabel?.text = message.created?.timeOfMessage()
    }
    
    private func setupViewIfIncoming(isTrue: Bool) {
        if isTrue {
            leadingConstraint?.constant = 20
            trailingConstraint?.constant = contentView.frame.width / 4
            bubbleView?.backgroundColor = currentTheme?.incomingMessageColor
        } else {
            leadingConstraint?.constant = contentView.frame.width / 4
            trailingConstraint?.constant = 20
            bubbleView?.backgroundColor = currentTheme?.outcomingMessageColor
        }
        
        backgroundColor = currentTheme?.backgroundColor
        messageTextLabel?.textColor = currentTheme?.fontColor
        dateLabel?.textColor = currentTheme?.fontColor
    }
    
}
