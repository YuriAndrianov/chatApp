//
//  Router.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 16.04.2022.
//

import UIKit

class Router: Routing {

    var navigationController: UINavigationController?
    var builder: Building?

    init(navigationController: UINavigationController, builder: Building) {
        self.navigationController = navigationController
        self.builder = builder
    }

    func showConversationList() {
        if let navigationController = navigationController {
            guard let conversationListVC = builder?.createConversationListModule(router: self) else { return }
            navigationController.pushViewController(conversationListVC, animated: true)
        }
    }

    func showConversation(channel: Channel) {
        if let navigationController = navigationController {
            guard let conversationVC = builder?.createConversationModule(channel: channel, router: self) else { return }
            navigationController.pushViewController(conversationVC, animated: true)
        }
    }
    
    func showSettings() {
        if let navigationController = navigationController {
            guard let themesVC = builder?.createSettingsModule(router: self) else { return }
            navigationController.pushViewController(themesVC, animated: true)
        }
    }
    
    func showMyProfile() {
        if let navigationController = navigationController {
            guard let profileVC = builder?.createMyProfileModule(router: self) else { return }
            let newNavVC = CustomNavigationController(rootViewController: profileVC)
            navigationController.visibleViewController?.present(newNavVC, animated: true, completion: nil)
        }

    }

}
