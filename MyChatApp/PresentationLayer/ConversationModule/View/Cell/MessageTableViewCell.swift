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
    
    private var currentTheme: ITheme? {
        return ThemePicker.shared.currentTheme
    }

    @IBOutlet weak var leadingConstraint: NSLayoutConstraint?
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint?
    @IBOutlet weak var textLabelTopConstraint: NSLayoutConstraint?
    @IBOutlet weak var messageTextLabel: UILabel?
    @IBOutlet weak var bubbleView: UIView?
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var messageImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel?.isHidden = false
        messageTextLabel?.isHidden = false
        messageImageView.isHidden = false
        textLabelTopConstraint?.constant = 40
        nameLabel?.text = nil
        messageTextLabel?.text = nil
        dateLabel?.text = nil
    }
    
    func configurateAsIncoming(with message: Message) {
        nameLabel?.isHidden = false
        textLabelTopConstraint?.constant = 40
        leadingConstraint?.constant = 20
        trailingConstraint?.constant = contentView.frame.width / 3
        bubbleView?.backgroundColor = currentTheme?.incomingMessageColor
        setupCell(with: message)
    }
    
    func configurateAsOutcoming(with message: Message) {
        nameLabel?.isHidden = true
        textLabelTopConstraint?.constant = 10
        leadingConstraint?.constant = contentView.frame.width / 3
        trailingConstraint?.constant = 20
        bubbleView?.backgroundColor = currentTheme?.outcomingMessageColor
        setupCell(with: message)
    }
    
    private func setupCell(with message: Message?) {
        backgroundColor = currentTheme?.backgroundColor
        messageTextLabel?.textColor = currentTheme?.fontColor
        nameLabel?.textColor = currentTheme?.fontColor
        dateLabel?.textColor = currentTheme?.fontColor
        
        nameLabel?.text = message?.senderName
        dateLabel?.text = message?.created.lastMessageDateFormat()
        
        fillWithContentFrom(message)
    }
    
    private func fillWithContentFrom(_ message: Message?) {
        if let text = message?.content {
            if let url = URL(string: text) {
                let networkService = NetworkService()
                networkService.request(from: url) { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let data):
                            if let image = UIImage(data: data) {
                                self?.messageTextLabel?.isHidden = true
                                self?.messageImageView.image = image
                            }
                        case .failure(let error):
                            self?.messageImageView.isHidden = true
                            self?.messageTextLabel?.text = "API is not supporting\n" + text
                            print(error.localizedDescription)
                        }
                    }
                }
            } else { messageTextLabel?.text = text }
        }
    }
    
}
