//
//  Router.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 16.04.2022.
//

import UIKit

final class Router: IRouter {
    
    var navigationController: UINavigationController
    var assembly: IAssembly
    
    init(navigationController: UINavigationController, assembly: IAssembly) {
        self.navigationController = navigationController
        self.assembly = assembly
    }
    
    func showConversationList() {
        let conversationListVC = assembly.createConversationListModule(router: self)
        navigationController.pushViewController(conversationListVC, animated: true)
    }
    
    func showConversation(channel: Channel) {
        let conversationVC = assembly.createConversationModule(channel: channel, router: self)
        navigationController.pushViewController(conversationVC, animated: true)
    }
    
    func showSettings() {
        let themesVC = assembly.createSettingsModule(router: self)
        navigationController.pushViewController(themesVC, animated: true)
    }
    
    func showMyProfile() {
        let profileVC = assembly.createMyProfileModule(router: self)
        let newNavVC = CustomNavigationController(rootViewController: profileVC)
        navigationController.visibleViewController?.present(newNavVC, animated: true, completion: nil)
    }
    
    func showNetworkPicker() {
        let networkPickerVC = assembly.createNetworkPickerModule(router: self)
        let newNavVC = CustomNavigationController(rootViewController: networkPickerVC)
        navigationController.visibleViewController?.present(newNavVC, animated: true, completion: nil)
    }
    
    func showMyProfileWithNewPhoto(_ newPhotoURL: String) {
        navigationController.visibleViewController?.dismiss(animated: true, completion: { [weak self] in
            if let profileVC = self?.navigationController.visibleViewController as? IProfileView {
                profileVC.setNewPhoto(newPhotoURL)
            } else if let conversationVC = self?.navigationController.visibleViewController as? IConversationView {
                conversationVC.sendPhoto(newPhotoURL)
            }
        })
    }
    
}
