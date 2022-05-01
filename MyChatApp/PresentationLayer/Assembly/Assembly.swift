//
//  ModuleBuilder.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 16.04.2022.
//

import UIKit

final class Assembly: IAssembly {
    
    func createConversationListModule(router: IRouter) -> UIViewController {
        let view = ConversationsListViewController()
        let coreDataManager = DataBaseService(coreDataStack: NewCoreDataStack())
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

    func createConversationModule(channel: Channel, router: IRouter) -> UIViewController {
        let view = ConversationViewController()
        let coreDataManager = DataBaseService(coreDataStack: NewCoreDataStack())
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
    
    func createSettingsModule(router: IRouter) -> UIViewController {
        let themePicker = ThemePicker.shared
        return ThemesViewController(with: themePicker)
    }
    
    func createMyProfileModule(router: IRouter) -> UIViewController {
        let view = ProfileViewController()
        
        let fileManager = DataManagerGCD.shared
        let imageManager = ImageManager.shared
        let themePicker = ThemePicker.shared
        let presenter = ProfilePresenter(view: view,
                                         fileManager: fileManager,
                                         imageManager: imageManager,
                                         themePicker: themePicker,
                                         router: router)
        view.presenter = presenter
        
        return view
    }
    
    func createNetworkPickerModule(router: IRouter) -> UIViewController {
        let view = NetworkPickerViewController()
        let photoFetcher = PhotoFetcher(networkService: NetworkService())
        let presenter = NetworkPickerPresenter(view: view,
                                               photoFetcher: photoFetcher,
                                               router: router)
        view.presenter = presenter
        return view
    }
    
}
