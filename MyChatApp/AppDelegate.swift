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

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        print(#function, "\nApplication is moving from \"not running\" to \"inactive\"\n")

        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        print(#function, "\nApplication moved from \"not running\" to \"inactive\"\n")

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print(#function, "\nApplication moved from \"inactive\" to \"active\"\n")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print(#function, "\nApplication moved from \"active\" to \"inactive\"\n")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print(#function, "\nApplication moved from \"inactive\" to \"background\"\n")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print(#function, "\nApplication is moving from \"background\" to \"active\"\n")
    }


    func applicationWillTerminate(_ application: UIApplication) {
        print(#function, "\nApplication moved from \"background\" to \"not running\"\n")
    }

}

