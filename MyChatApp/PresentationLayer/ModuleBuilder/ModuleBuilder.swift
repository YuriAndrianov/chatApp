//
//  ModuleBuilder.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 16.04.2022.
//

import UIKit

class ModuleBuilder: Building {

    func createConversationListModule(router: Routing) -> UIViewController {
        let view = ConversationsListViewController()
        let coreDataManager = DataBaseChatManager(coreDataStack: NewCoreDataStack())
        let firestoreManager = FirestoreManager()
        let themePicker = ThemePicker.shared
        let presenter = ConversationListPresenter(view: view,
                                                  coreDataManager: coreDataManager,
                                                  firestoreManager: firestoreManager,
                                                  themePicker: themePicker,
                                                  router: router)
        view.presenter = presenter

        return view
    }

    func createConversationModule(channel: Channel, router: Routing) -> UIViewController {
        let view = ConversationViewController()
        let coreDataManager = DataBaseChatManager(coreDataStack: NewCoreDataStack())
        let firestoreManager = FirestoreManager()
        firestoreManager.channel = channel
        let themePicker = ThemePicker.shared
        
        let presenter = ConversationPresenter(view: view,
                                              coreDataManager: coreDataManager,
                                              firestoreManager: firestoreManager,
                                              themePicker: themePicker,
                                              router: router,
                                              channel: channel)
        view.presenter = presenter

        return view
        
    }
    
    func createSettingsModule(router: Routing) -> UIViewController {
        let themePicker = ThemePicker.shared
        return ThemesViewController(with: themePicker)
    }
    
    func createMyProfileModule(router: Routing) -> UIViewController {
        let fileManager = DataManagerGCD.shared
        let imageManager = ImageManager.shared
        let themePicker = ThemePicker.shared
        
        return ProfileViewController(with: fileManager,
                                              imageManager: imageManager,
                                              themePicker: themePicker)
    }

}
