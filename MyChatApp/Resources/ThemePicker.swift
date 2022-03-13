//
//  ThemePicker.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 12.03.2022.
//

import UIKit

protocol ThemePickerProtocol: AnyObject {
    
    func apply(_ theme: ThemePicker.ThemeType)
    
}

final class ThemePicker: ThemePickerProtocol {
    
    static let shared = ThemePicker()
    
    static var currentTheme: ThemeProtocol?
    
    private init() {}
    
    enum ThemeType {
        case classic
        case day
        case night
    }
    
    func apply(_ theme: ThemePicker.ThemeType) {
        
        switch theme {
        case .classic:
            ThemePicker.currentTheme = ClassicTheme()
            UserDefaults.standard.set("classic", forKey: "currentTheme")
        case .day:
            ThemePicker.currentTheme = DayTheme()
            UserDefaults.standard.set("day", forKey: "currentTheme")
        case .night:
            ThemePicker.currentTheme = NightTheme()
            UserDefaults.standard.set("night", forKey: "currentTheme")
        }
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = ThemePicker.currentTheme?.navBarColor
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor : ThemePicker.currentTheme?.fontColor as Any]
        navBarAppearance.titleTextAttributes = [.foregroundColor : ThemePicker.currentTheme?.fontColor as Any]
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().tintColor = ThemePicker.currentTheme?.barButtonColor
        
        UIApplication.shared.statusBarStyle = ThemePicker.currentTheme is NightTheme ? .lightContent : .darkContent
        UIApplication.shared.keyWindow?.reload()
    }
    
    func applySavedTheme() {
        if let savedTheme = UserDefaults.standard.value(forKey: "currentTheme") as? String {
            switch savedTheme {
            case "classic": apply(.classic)
            case "day": apply(.day)
            case "night": apply(.night)
            default: apply(.classic)
            }
        } else { apply(.classic) }
    }

}


