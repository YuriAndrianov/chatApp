//
//  MockModuleAssembly.swift
//  MyChatAppTests
//
//  Created by Юрий Андрианов on 16.05.2022.
//

import UIKit
@testable import MyChatApp

final class MockModuleAssembly: IModuleAssembly {

    var invokedCreateConversationListModule = false
    var invokedCreateConversationListModuleCount = 0
    var invokedCreateConversationListModuleParameters: (router: IRouter, Void)?
    var invokedCreateConversationListModuleParametersList = [(router: IRouter, Void)]()
    var stubbedCreateConversationListModuleResult: UIViewController!

    func createConversationListModule(router: IRouter) -> UIViewController {
        invokedCreateConversationListModule = true
        invokedCreateConversationListModuleCount += 1
        invokedCreateConversationListModuleParameters = (router, ())
        invokedCreateConversationListModuleParametersList.append((router, ()))
        return stubbedCreateConversationListModuleResult
    }

    var invokedCreateConversationModule = false
    var invokedCreateConversationModuleCount = 0
    var invokedCreateConversationModuleParameters: (channel: Channel, router: IRouter)?
    var invokedCreateConversationModuleParametersList = [(channel: Channel, router: IRouter)]()
    var stubbedCreateConversationModuleResult: UIViewController!

    func createConversationModule(channel: Channel, router: IRouter) -> UIViewController {
        invokedCreateConversationModule = true
        invokedCreateConversationModuleCount += 1
        invokedCreateConversationModuleParameters = (channel, router)
        invokedCreateConversationModuleParametersList.append((channel, router))
        return stubbedCreateConversationModuleResult
    }

    var invokedCreateSettingsModule = false
    var invokedCreateSettingsModuleCount = 0
    var invokedCreateSettingsModuleParameters: (router: IRouter, Void)?
    var invokedCreateSettingsModuleParametersList = [(router: IRouter, Void)]()
    var stubbedCreateSettingsModuleResult: UIViewController!

    func createSettingsModule(router: IRouter) -> UIViewController {
        invokedCreateSettingsModule = true
        invokedCreateSettingsModuleCount += 1
        invokedCreateSettingsModuleParameters = (router, ())
        invokedCreateSettingsModuleParametersList.append((router, ()))
        return stubbedCreateSettingsModuleResult
    }

    var invokedCreateMyProfileModule = false
    var invokedCreateMyProfileModuleCount = 0
    var invokedCreateMyProfileModuleParameters: (router: IRouter, Void)?
    var invokedCreateMyProfileModuleParametersList = [(router: IRouter, Void)]()
    var stubbedCreateMyProfileModuleResult: UIViewController!

    func createMyProfileModule(router: IRouter) -> UIViewController {
        invokedCreateMyProfileModule = true
        invokedCreateMyProfileModuleCount += 1
        invokedCreateMyProfileModuleParameters = (router, ())
        invokedCreateMyProfileModuleParametersList.append((router, ()))
        return stubbedCreateMyProfileModuleResult
    }

    var invokedCreateNetworkPickerModule = false
    var invokedCreateNetworkPickerModuleCount = 0
    var invokedCreateNetworkPickerModuleParameters: (router: IRouter, Void)?
    var invokedCreateNetworkPickerModuleParametersList = [(router: IRouter, Void)]()
    var stubbedCreateNetworkPickerModuleResult: UIViewController!

    func createNetworkPickerModule(router: IRouter) -> UIViewController {
        invokedCreateNetworkPickerModule = true
        invokedCreateNetworkPickerModuleCount += 1
        invokedCreateNetworkPickerModuleParameters = (router, ())
        invokedCreateNetworkPickerModuleParametersList.append((router, ()))
        return stubbedCreateNetworkPickerModuleResult
    }
}
