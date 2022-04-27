//
//  Router.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 16.04.2022.
//

import UIKit

class Router: IRouter {
    
    var navigationController: UINavigationController?
    var assembly: IAssembly?
    
    init(navigationController: UINavigationController, assembly: IAssembly) {
        self.navigationController = navigationController
        self.assembly = assembly
    }
    
    func showConversationList() {
        if let navigationController = navigationController {
            guard let conversationListVC = assembly?.createConversationListModule(router: self) else { return }
            navigationController.pushViewController(conversationListVC, animated: true)
        }
    }
    
    func showConversation(channel: Channel) {
        if let navigationController = navigationController {
            guard let conversationVC = assembly?.createConversationModule(channel: channel, router: self) else { return }
            navigationController.pushViewController(conversationVC, animated: true)
        }
    }
    
    func showSettings() {
        if let navigationController = navigationController {
            guard let themesVC = assembly?.createSettingsModule(router: self) else { return }
            navigationController.pushViewController(themesVC, animated: true)
        }
    }
    
    func showMyProfile() {
        if let navigationController = navigationController {
            guard let profileVC = assembly?.createMyProfileModule(router: self) else { return }
            let newNavVC = CustomNavigationController(rootViewController: profileVC)
            navigationController.visibleViewController?.present(newNavVC, animated: true, completion: nil)
        }
    }
    
    func showNetworkPicker() {
        if let navigationController = navigationController {
            guard let networkPickerVC = assembly?.createNetworkPickerModule(router: self) else { return }
            let newNavVC = CustomNavigationController(rootViewController: networkPickerVC)
            navigationController.visibleViewController?.present(newNavVC, animated: true, completion: nil)
        }
    }
    
    func showMyProfileWithNewPhoto(_ newPhotoURL: String) {
        if let navigationController = navigationController {
            navigationController.visibleViewController?.dismiss(animated: true, completion: {
                if let profileVC = navigationController.visibleViewController as? IProfileView {
                    profileVC.setNewPhoto(newPhotoURL)
                }
            })
        }
    }
    
}
