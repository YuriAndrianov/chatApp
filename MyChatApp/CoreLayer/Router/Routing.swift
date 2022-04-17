//
//  Routing.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 17.04.2022.
//

import UIKit

protocol Routing {

    var navigationController: UINavigationController? { get set }
    var builder: Building? { get set }

    func showConversationList()
    func showConversation(channel: Channel)
    func showSettings()
    func showMyProfile()

}
