//
//  CustomInputView.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 07.04.2022.
//

import UIKit

final class CustomInputView: UIView {
    
    private let currentTheme = ThemePicker.shared.currentTheme
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = currentTheme?.backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var textField: UITextField = {
        let field = UITextField()
        field.font = .systemFont(ofSize: 15)
        field.textColor = currentTheme?.fontColor
        field.attributedPlaceholder = NSAttributedString(
            string: "Message...",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        field.autocorrectionType = .no
        field.layer.cornerRadius = 6
        field.layer.borderColor = UIColor.systemGray.cgColor
        field.layer.borderWidth = 0.5
        field.translatesAutoresizingMaskIntoConstraints = false
        field.keyboardAppearance = currentTheme is NightTheme ? .dark : .default
        return field
    }()
    
    lazy var textView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 15)
        tv.textColor = currentTheme?.fontColor
        tv.autocorrectionType = .no
        tv.layer.cornerRadius = 10
        tv.layer.borderColor = UIColor.label.cgColor
        tv.layer.borderWidth = 0.5
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.keyboardAppearance = currentTheme is NightTheme ? .dark : .default
        return tv
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.setTitleColor(.systemGray, for: .disabled)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        addSubview(contentView)
        contentView.addSubview(textView)
        contentView.addSubview(sendButton)
        
        if currentTheme is NightTheme {
            textView.backgroundColor = UIColor(named: "textViewBGColor") ?? .darkGray
        }
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -5),
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            sendButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            sendButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }

}
