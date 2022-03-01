//
//  AppDelegate.swift
//  MyChatApp
//
//  Created by MacBook on 23.02.2022.
//

import UIKit

// Если я правильно понял задание со звездочкой, то вот вариант моего решения
/// If Product -> Scheme -> Edit Scheme... -> Run -> Build Configuration is "Release"
/// then print fuction is disabled, else if Build Configuration is "Debug" it is enabled

func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
#if DEBUG
    items.forEach {
        Swift.print($0, separator: separator, terminator: terminator)
    }
#endif
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print(#function, "Application moved from \"not running\" to \"inactive\"")
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let profileVC = ChatViewController()
        let navigationController = UINavigationController(rootViewController: profileVC)
        
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print(#function, "Application moved from \"inactive\" to \"active\"")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print(#function, "Application moved from \"active\" to \"inactive\"")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print(#function, "Application moved from \"inactive\" to \"background\"")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print(#function, "Application is moving from \"background\" to \"active\"")
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        print(#function, "Application moved from \"background\" to \"not running\"")
    }
    
}

