//
//  IRouter.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 17.04.2022.
//

import UIKit

protocol IRouter {
    
    init(navigationController: CustomNavigationController, assembly: IModuleAssembly)
    
    func showConversationList()
    func showConversation(channel: Channel)
    func showSettings()
    func showMyProfile()
    func showNetworkPicker()
    func showMyProfileWithNewPhoto(_ newPhotoURL: String)
}
