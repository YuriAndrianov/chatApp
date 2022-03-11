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

    @IBOutlet weak var leadingConstraint: NSLayoutConstraint?
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint?
    @IBOutlet weak var messageTextLabel: UILabel?
    @IBOutlet weak var bubbleView: UIView?
    @IBOutlet weak var dateLabel: UILabel?

    func configure(with message: Message) {
        self.isIncoming = message.isIncoming
        self.messageTextLabel?.text = message.text
        self.dateLabel?.text = message.date?.timeOfMessage()
    }
    
    private func setupViewIfIncoming(isTrue: Bool) {
        if isTrue {
            leadingConstraint?.constant = 20
            trailingConstraint?.constant = contentView.frame.width / 4
            bubbleView?.backgroundColor = .systemGray5
        } else {
            leadingConstraint?.constant = contentView.frame.width / 4
            trailingConstraint?.constant = 20
            bubbleView?.backgroundColor = UIColor(named: "onlineColor")
        }
    }
}

extension MessageTableViewCell: MessageCellConfiguration {
    
    var isIncoming: Bool {
        get { return false }
        set { setupViewIfIncoming(isTrue: newValue) }
    }
    
    var messageText: String? {
        get { return nil }
        set {
            if let newValue = newValue {
                messageTextLabel?.text = newValue
            }
        }
    }
    
}
