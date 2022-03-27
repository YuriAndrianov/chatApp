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
    
    private(set) var currentTheme: ThemeProtocol?
    
    weak var delegate: ThemePickerProtocol?
    
    private init() {}
    
    enum ThemeType {
        case classic
        case day
        case night
    }
    
    func applySavedTheme() {
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
        navBarAppearance.backgroundColor = currentTheme?.navBarColor
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: currentTheme?.fontColor as Any]
        navBarAppearance.titleTextAttributes = [.foregroundColor: currentTheme?.fontColor as Any]
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().tintColor = currentTheme?.barButtonColor
        
        UIApplication.shared.windows.first { $0.isKeyWindow }?.reload()
        
        // при использовании делегата
        delegate?.updateUI(with: currentTheme)
        
        // при использовании completion
        completion?(currentTheme ?? ClassicTheme())
    }
    
    private func savePreffered(theme: ThemeType, for user: User) {
        switch theme {
        case .classic:
            currentTheme = ClassicTheme()
            user.preferedTheme = "classic"
        case .day:
            currentTheme = DayTheme()
            user.preferedTheme = "day"
        case .night:
            currentTheme = NightTheme()
            user.preferedTheme = "night"
        }
        
        DataManagerGCD.shared.writeToFile(user) { _ in }
    }
    
}
