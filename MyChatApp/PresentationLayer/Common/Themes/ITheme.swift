//
//  ThemeProtocol.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 12.03.2022.
//

import UIKit

protocol ITheme: AnyObject {
    
    var statusBarStyle: UIStatusBarStyle { get }
    var keyboardAppearance: UIKeyboardAppearance { get }
    var backgroundColor: UIColor { get }
    var fontColor: UIColor { get }
    var incomingMessageColor: UIColor { get }
    var outcomingMessageColor: UIColor { get }
    var navBarColor: UIColor { get }
    var saveButtonColor: UIColor { get }
    var barButtonColor: UIColor { get }
}
