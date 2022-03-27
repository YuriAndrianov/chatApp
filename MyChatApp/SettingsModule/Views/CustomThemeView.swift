//
//  CustomThemeView.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 12.03.2022.
//

import UIKit

final class CustomThemeView: UIView {

    @IBOutlet weak var contentView: UIView?
    @IBOutlet weak var button: ThemeButton?
    @IBOutlet weak var label: UILabel?
    
    let tapGesture = UITapGestureRecognizer()
    var theme: ThemePicker.ThemeType?

    var isButtonHighlited: Bool = false {
        didSet {
            if isButtonHighlited {
                UIView.animate(withDuration: 0.05) {
                    self.button?.layer.borderColor = UIColor.link.cgColor
                }
            } else {
                UIView.animate(withDuration: 0.05) {
                    self.button?.layer.borderColor = UIColor.systemGray6.cgColor
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        Bundle.main.loadNibNamed("CustomThemeView", owner: self, options: nil)
        
        guard let contentView = contentView else { return }
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        label?.isUserInteractionEnabled = true
        label?.addGestureRecognizer(tapGesture)
        label?.textColor = ThemePicker.shared.currentTheme?.fontColor
    }
    
    func configurate(with theme: ThemePicker.ThemeType) {
        self.theme = theme
        
        switch theme {
        case .classic:
            let classicTheme = ClassicTheme()
            button?.incomingMessageView?.backgroundColor = classicTheme.incomingMessageColor
            button?.outcomingMessageView?.backgroundColor = classicTheme.outcomingMessageColor
            button?.contentView?.backgroundColor = classicTheme.backgroundColor
            label?.text = "Classic"
        case .day:
            let dayTheme = DayTheme()
            button?.incomingMessageView?.backgroundColor = dayTheme.incomingMessageColor
            button?.outcomingMessageView?.backgroundColor = dayTheme.outcomingMessageColor
            button?.contentView?.backgroundColor = dayTheme.backgroundColor
            label?.text = "Day"
        case .night:
            let nightTheme = NightTheme()
            button?.incomingMessageView?.backgroundColor = nightTheme.incomingMessageColor
            button?.outcomingMessageView?.backgroundColor = nightTheme.outcomingMessageColor
            button?.contentView?.backgroundColor = nightTheme.backgroundColor
            label?.text = "Night"
        }
    }
    
}
