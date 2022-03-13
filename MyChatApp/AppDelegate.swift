//
//  AppDelegate.swift
//  MyChatApp
//
//  Created by MacBook on 23.02.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let conversationsVC = ConversationsListViewController()
        let navigationController = UINavigationController(rootViewController: conversationsVC)
       
        ThemePicker.shared.apply(.classic)
        
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
}

