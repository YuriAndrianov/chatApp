//
//  ThemeButton.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 23.03.2022.
//

import UIKit

class ThemeButton: UIButton {
    
    @IBOutlet weak var contentView: UIView?
    @IBOutlet weak var incomingMessageView: UIView?
    @IBOutlet weak var outcomingMessageView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        Bundle.main.loadNibNamed("ThemeButton", owner: self, options: nil)
        
        guard let contentView = contentView else { return }
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        //        incomingMessageView?.backgroundColor = ClassicTheme().incomingMessageColor
        //        outcomingMessageView?.backgroundColor = ClassicTheme().outcomingMessageColor
        
        clipsToBounds = true
        layer.cornerRadius = 20
        layer.borderWidth = 3
        layer.borderColor = UIColor.systemGray5.cgColor
        isUserInteractionEnabled = true
    }
    
}
