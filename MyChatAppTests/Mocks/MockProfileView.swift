//
//  MockProfileView.swift
//  MyChatAppTests
//
//  Created by Юрий Андрианов on 16.05.2022.
//

import UIKit
@testable import MyChatApp

final class MockProfileView: IProfileView {

    var invokedConfigureUIWith = false
    var invokedConfigureUIWithCount = 0
    var invokedConfigureUIWithParameters: (user: User, Void)?
    var invokedConfigureUIWithParametersList = [(user: User, Void)]()

    func configureUI(_ user: User) {
        invokedConfigureUIWith = true
        invokedConfigureUIWithCount += 1
        invokedConfigureUIWithParameters = (user, ())
        invokedConfigureUIWithParametersList.append((user, ()))
    }

    var invokedSetUserImage = false
    var invokedSetUserImageCount = 0
    var invokedSetUserImageParameters: (image: UIImage?, Void)?
    var invokedSetUserImageParametersList = [(image: UIImage?, Void)]()

    func setUserImage(_ image: UIImage?) {
        invokedSetUserImage = true
        invokedSetUserImageCount += 1
        invokedSetUserImageParameters = (image, ())
        invokedSetUserImageParametersList.append((image, ()))
    }

    var invokedSetNewPhoto = false
    var invokedSetNewPhotoCount = 0
    var invokedSetNewPhotoParameters: (url: String, Void)?
    var invokedSetNewPhotoParametersList = [(url: String, Void)]()

    func setNewPhoto(_ url: String) {
        invokedSetNewPhoto = true
        invokedSetNewPhotoCount += 1
        invokedSetNewPhotoParameters = (url, ())
        invokedSetNewPhotoParametersList.append((url, ()))
    }

    var invokedDisableSaveButton = false
    var invokedDisableSaveButtonCount = 0

    func disableSaveButton() {
        invokedDisableSaveButton = true
        invokedDisableSaveButtonCount += 1
    }
}
