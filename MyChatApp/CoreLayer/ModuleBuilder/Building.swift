//
//  Building.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 17.04.2022.
//

import UIKit

protocol Building {

    func createConversationListModule(router: Routing) -> UIViewController

    func createConversationModule(channel: Channel, router: Routing) -> UIViewController
    
    func createSettingsModule(router: Routing) -> UIViewController
    
    func createMyProfileModule(router: Routing) -> UIViewController

}
