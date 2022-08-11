//
//  ModuleBuilder.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 16.04.2022.
//

import UIKit

final class ModuleAssembly: IModuleAssembly {
    
    func createConversationListModule(router: IRouter) -> UIViewController {
        let coreDataManager = DataBaseService(coreDataStack: NewCoreDataStack())
        let firestoreManager = FirestoreService()
        let themePicker = ThemePicker.shared
        let view = ConversationsListViewController(themePicker: themePicker, tableView: UITableView())
        let presenter = ConversationListPresenter(view: view,
                                                  coreDataManager: coreDataManager,
                                                  firestoreManager: firestoreManager,
                                                  router: router)
        view.presenter = presenter
        
        return view
    }
    
    func createConversationModule(channel: Channel, router: IRouter) -> UIViewController {
        let coreDataManager = DataBaseService(coreDataStack: NewCoreDataStack())
        let firestoreManager = FirestoreService()
        firestoreManager.channel = channel
        let themePicker = ThemePicker.shared
        let view = ConversationViewController(themePicker: themePicker, tableView: UITableView())
        
        let presenter = ConversationPresenter(view: view,
                                              coreDataManager: coreDataManager,
                                              firestoreManager: firestoreManager,
                                              dataService: DataManagerGCD.shared,
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
        let imageManager = ImageService.shared
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
        let themePicker = ThemePicker.shared
        let photoFetcher = PhotoFetcher(networkService: NetworkService())
        let presenter = NetworkPickerPresenter(view: view,
                                               photoFetcher: photoFetcher,
                                               router: router)
        view.themePicker = themePicker
        view.presenter = presenter
        
        return view
    }
}
