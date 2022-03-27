//
//  NightTheme.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 12.03.2022.
//

import UIKit

final class NightTheme: ThemeProtocol {
    
    var backgroundColor: UIColor = UIColor(named: "nightThemeBackgroundColor") ?? .systemBackground
    var fontColor: UIColor = UIColor(named: "nightFontColor") ?? .label
    var incomingMessageColor: UIColor = UIColor(named: "nightIncoming") ?? .systemGray5
    var outcomingMessageColor: UIColor = UIColor(named: "nightOutcoming") ?? .systemBlue
    var navBarColor: UIColor = UIColor(named: "nightNavBarBGColor") ?? .secondarySystemBackground
    var saveButtonColor: UIColor = UIColor(named: "nightSaveButtonColor") ?? .systemGray5
    var barButtonColor: UIColor = UIColor(named: "nightBarButtonColor") ?? .systemGray
    
}
