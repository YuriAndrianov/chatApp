//
//  ModuleBuilder.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 16.04.2022.
//

import Foundation
import UIKit

protocol BuilderProtocol {

    func createConversationListModule(router: RouterProtocol) -> UIViewController

    func createConversationModule(channel: Channel, router: RouterProtocol) -> UIViewController
    
    func createSettingsModule(router: RouterProtocol) -> UIViewController
    
    func createMyProfileModule(router: RouterProtocol) -> UIViewController

}

class ModuleBuilder: BuilderProtocol {

    func createConversationListModule(router: RouterProtocol) -> UIViewController {
        let view = ConversationsListViewController()
        let coreDataManager = DataBaseChatManager(coreDataStack: NewCoreDataStack())
        let firestoreManager = FirestoreManager()
        let presenter = ConversationListPresenter(view: view,
                                                  coreDataManager: coreDataManager,
                                                  firestoreManager: firestoreManager,
                                                  router: router)
        view.presenter = presenter

        return view
    }

    func createConversationModule(channel: Channel, router: RouterProtocol) -> UIViewController {
        let view = ConversationViewController()
        let coreDataManager = DataBaseChatManager(coreDataStack: NewCoreDataStack())
        let firestoreManager = FirestoreManager()
        firestoreManager.channel = channel
        
        let presenter = ConversationPresenter(view: view,
                                              coreDataManager: coreDataManager,
                                              firestoreManager: firestoreManager,
                                              router: router,
                                              channel: channel)
        view.presenter = presenter

        return view
        
    }
    
    func createSettingsModule(router: RouterProtocol) -> UIViewController {
        let settingsVC = ThemesViewController()
        return settingsVC
    }
    
    func createMyProfileModule(router: RouterProtocol) -> UIViewController {
        let myProfileVC = ProfileViewController()
        return myProfileVC
    }

}
