//
//  ThemeService.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 17.04.2022.
//

import Foundation

protocol ThemeService: AnyObject {
    
    var currentTheme: Theme? { get }
    
    func applySavedTheme()
    
    func apply(_ theme: ThemeType, completion: ((Theme) -> Void)?)
    
}

enum ThemeType {
    
    case classic
    case day
    case night
    
}
