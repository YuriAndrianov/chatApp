//
//  IAssembly.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 17.04.2022.
//

import UIKit

protocol IAssembly {

    func createConversationListModule(router: IRouter) -> UIViewController

    func createConversationModule(channel: Channel, router: IRouter) -> UIViewController
    
    func createSettingsModule(router: IRouter) -> UIViewController
    
    func createMyProfileModule(router: IRouter) -> UIViewController
    
    func createNetworkPickerModule(router: IRouter) -> UIViewController

}
