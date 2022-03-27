//
//  AppDelegate.swift
//  MyChatApp
//
//  Created by MacBook on 23.02.2022.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let conversationsVC = ConversationsListViewController()
        let navigationController = CustomNavigationController(rootViewController: conversationsVC)
       
        ThemePicker.shared.applySavedTheme()
        FirebaseApp.configure()
        
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
}
