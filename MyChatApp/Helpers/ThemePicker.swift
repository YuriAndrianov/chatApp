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
//        guard let user = DataManagerGCD.shared.readFromFile() else {
//            apply(.classic, completion: nil)
//            return
//        }
//
//        if let savedTheme = user.preferedTheme {
//            switch savedTheme {
//            case "classic": apply(.classic, completion: nil)
//            case "day": apply(.day, completion: nil)
//            case "night": apply(.night, completion: nil)
//            default: apply(.classic, completion: nil)
//            }
//        } else { apply(.classic, completion: nil) }
        
        DataManagerGCD.shared.readFromFile { [weak self] user in
            guard let self = self else { return }
            guard let user = user else {
                self.apply(.classic, completion: nil)
                return
            }
            
            if let savedTheme = user.preferedTheme {
                switch savedTheme {
                case "classic": self.apply(.classic, completion: nil)
                case "day": self.apply(.day, completion: nil)
                case "night": self.apply(.night, completion: nil)
                default: self.apply(.classic, completion: nil)
                }
            } else { self.apply(.classic, completion: nil) }
            
        }
    }

    func apply(_ theme: ThemePicker.ThemeType, completion: ((ThemeProtocol) -> Void)?) {
        
//        if let user = DataManagerGCD.shared.readFromFile() {
//            savePreffered(theme: theme, for: user)
//        } else {
//            let user = User()
//            savePreffered(theme: theme, for: user)
//        }
        
        DataManagerGCD.shared.readFromFile { [weak self] user in
            guard let self = self else { return }
            
            if let user = user {
                self.savePreffered(theme: theme, for: user)
            } else {
                let user = User()
                self.savePreffered(theme: theme, for: user)
            }
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
    
    private func savePreffered(theme: ThemeType, for user: User) {
        switch theme {
        case .classic:
            ThemePicker.currentTheme = ClassicTheme()
            user.preferedTheme = "classic"
        case .day:
            ThemePicker.currentTheme = DayTheme()
            user.preferedTheme = "day"
        case .night:
            ThemePicker.currentTheme = NightTheme()
            user.preferedTheme = "night"
        }
        
        DataManagerGCD.shared.writeToFile(user) { _ in }
    }
    
}


