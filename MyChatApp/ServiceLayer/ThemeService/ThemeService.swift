//
//  ThemeService.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 17.04.2022.
//

import Foundation

protocol ThemeService: AnyObject {
    
    var currentTheme: ITheme? { get }
    
    func applySavedTheme()
    
    func apply(_ theme: ThemeType, completion: ((ITheme) -> Void)?)
    
}

enum ThemeType {
    
    case classic
    case day
    case night
    
}
