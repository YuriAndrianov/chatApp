//
//  ThemeHandling.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 17.04.2022.
//

import Foundation

protocol ThemeHandling: AnyObject {
    
    var currentTheme: ThemeProtocol? { get }
    
    func applySavedTheme()
    
    func apply(_ theme: ThemeType, completion: ((ThemeProtocol) -> Void)?)
    
}

enum ThemeType {
    
    case classic
    case day
    case night
    
}
