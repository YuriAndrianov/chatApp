//
//  ThemePicker.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 12.03.2022.
//

import UIKit

protocol ThemePickerProtocol: AnyObject {
    
    func updateUI(with theme: ThemeProtocol?)
    
}

final class ThemePicker {
    
    static let shared = ThemePicker()
    
    static var currentTheme: ThemeProtocol?
    
    weak var delegate: ThemePickerProtocol?
    
    private init() {}
    
    enum ThemeType {
        case classic
        case day
        case night
    }
    
    func applySavedTheme() {
        if let savedTheme = UserDefaults.standard.value(forKey: "currentTheme") as? String {
            switch savedTheme {
            case "classic": apply(.classic, completion: nil)
            case "day": apply(.day, completion: nil)
            case "night": apply(.night, completion: nil)
            default: apply(.classic, completion: nil)
            }
        } else { apply(.classic, completion: nil) }
    }

    func apply(_ theme: ThemePicker.ThemeType, completion: ((ThemeProtocol) -> Void)?) {
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
        
        UIApplication.shared.windows.first { $0.isKeyWindow }?.reload()
        
        // при использовании делегата
        delegate?.updateUI(with: ThemePicker.currentTheme)
        
        // при использовании completion
        completion?(ThemePicker.currentTheme ?? ClassicTheme())
    }
    
}


