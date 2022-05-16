//
//  MockNetworkPickerView.swift
//  MyChatAppTests
//
//  Created by Юрий Андрианов on 16.05.2022.
//

import Foundation
@testable import MyChatApp

final class MockNetworkPickerView: INetworkPickerView {

    var invokedGetPhotoItemsSuccess = false
    var invokedGetPhotoItemsSuccessCount = 0

    func getPhotoItemsSuccess() {
        invokedGetPhotoItemsSuccess = true
        invokedGetPhotoItemsSuccessCount += 1
    }

    var invokedGetPhotoItemsFailure = false
    var invokedGetPhotoItemsFailureCount = 0

    func getPhotoItemsFailure() {
        invokedGetPhotoItemsFailure = true
        invokedGetPhotoItemsFailureCount += 1
    }
}
