//
//  ClassicTheme.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 12.03.2022.
//

import UIKit

final class ClassicTheme: ITheme {
    
    var backgroundColor: UIColor = UIColor(named: "classicThemeBackgroundColor") ?? .systemBackground
    var fontColor: UIColor = UIColor(named: "classicFontColor") ?? .label
    var incomingMessageColor: UIColor = UIColor(named: "classicIncoming") ?? .systemGray5
    var outcomingMessageColor: UIColor = UIColor(named: "classicOutcoming") ?? .systemBlue
    var navBarColor: UIColor = UIColor(named: "classicNavBarBGColor") ?? .secondarySystemBackground
    var saveButtonColor: UIColor = UIColor(named: "classicSaveButtonColor") ?? .systemGray5
    var barButtonColor: UIColor = UIColor(named: "classicBarButtonColor") ?? .systemGray
    
}
