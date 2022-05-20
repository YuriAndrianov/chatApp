//
//  MockRouter.swift
//  MyChatAppTests
//
//  Created by Юрий Андрианов on 16.05.2022.
//

import Foundation
@testable import MyChatApp

final class MockRouter: IRouter {

    required init(navigationController: CustomNavigationController, assembly: IModuleAssembly) {}

    var invokedShowConversationList = false
    var invokedShowConversationListCount = 0

    func showConversationList() {
        invokedShowConversationList = true
        invokedShowConversationListCount += 1
    }

    var invokedShowConversation = false
    var invokedShowConversationCount = 0
    var invokedShowConversationParameters: (channel: Channel, Void)?
    var invokedShowConversationParametersList = [(channel: Channel, Void)]()

    func showConversation(channel: Channel) {
        invokedShowConversation = true
        invokedShowConversationCount += 1
        invokedShowConversationParameters = (channel, ())
        invokedShowConversationParametersList.append((channel, ()))
    }

    var invokedShowSettings = false
    var invokedShowSettingsCount = 0

    func showSettings() {
        invokedShowSettings = true
        invokedShowSettingsCount += 1
    }

    var invokedShowMyProfile = false
    var invokedShowMyProfileCount = 0

    func showMyProfile() {
        invokedShowMyProfile = true
        invokedShowMyProfileCount += 1
    }

    var invokedShowNetworkPicker = false
    var invokedShowNetworkPickerCount = 0

    func showNetworkPicker() {
        invokedShowNetworkPicker = true
        invokedShowNetworkPickerCount += 1
    }

    var invokedShowMyProfileWithNewPhoto = false
    var invokedShowMyProfileWithNewPhotoCount = 0
    var invokedShowMyProfileWithNewPhotoParameters: (newPhotoURL: String, Void)?
    var invokedShowMyProfileWithNewPhotoParametersList = [(newPhotoURL: String, Void)]()

    func showMyProfileWithNewPhoto(_ newPhotoURL: String) {
        invokedShowMyProfileWithNewPhoto = true
        invokedShowMyProfileWithNewPhotoCount += 1
        invokedShowMyProfileWithNewPhotoParameters = (newPhotoURL, ())
        invokedShowMyProfileWithNewPhotoParametersList.append((newPhotoURL, ()))
    }
}
