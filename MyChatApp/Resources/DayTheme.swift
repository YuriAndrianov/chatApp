//
//  DayTheme.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 12.03.2022.
//

import UIKit

final class DayTheme: ThemeProtocol {
    
    var backGroundColor: UIColor = UIColor(named: "dayThemeBackGroundColor") ?? .systemBackground
    var fontColor: UIColor = UIColor(named: "dayFontColor") ?? .label
    var incomingMessageColor: UIColor = UIColor(named: "dayIncoming") ?? .systemGray5
    var outcomingMessageColor: UIColor = UIColor(named: "dayOutcoming") ?? .systemBlue
    var navBarColor: UIColor = UIColor(named: "dayNavBarBGColor") ?? .secondarySystemBackground
    var saveButtonColor: UIColor = UIColor(named: "daySaveButtonColor") ?? .systemGray5
    var barButtonColor: UIColor = UIColor(named: "dayBarButtonColor") ?? .systemGray
    
}
