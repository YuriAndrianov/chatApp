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
        switch theme {
        case .classic:
            button?.incomingMessageView?.backgroundColor = ClassicTheme().incomingMessageColor
            button?.outcomingMessageView?.backgroundColor = ClassicTheme().outcomingMessageColor
            button?.contentView?.backgroundColor = ClassicTheme().backGroundColor
            label?.text = "Classic"
        case .day:
            button?.incomingMessageView?.backgroundColor = DayTheme().incomingMessageColor
            button?.outcomingMessageView?.backgroundColor = DayTheme().outcomingMessageColor
            button?.contentView?.backgroundColor = DayTheme().backGroundColor
            label?.text = "Day"
        case .night:
            button?.incomingMessageView?.backgroundColor = NightTheme().incomingMessageColor
            button?.outcomingMessageView?.backgroundColor = NightTheme().outcomingMessageColor
            button?.contentView?.backgroundColor = NightTheme().backGroundColor
            label?.text = "Night"
        }
    }
    
}
