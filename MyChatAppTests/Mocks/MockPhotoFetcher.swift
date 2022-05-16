//
//  MockPhotoFetcher.swift
//  MyChatAppTests
//
//  Created by Юрий Андрианов on 16.05.2022.
//

import Foundation
@testable import MyChatApp

final class MockPhotoFetcher: PhotoFetching {

    var invokedGetPhotoItems = false
    var invokedGetPhotoItemsCount = 0
    var invokedGetPhotoItemsParameters: (query: String, quantity: Int)?
    var invokedGetPhotoItemsParametersList = [(query: String, quantity: Int)]()
    var stubbedGetPhotoItemsCompletionResult: (Result<[PhotoItem]?, Error>, Void)?

    func getPhotoItems(query: String, quantity: Int, _ completion: @escaping (Result<[PhotoItem]?, Error>) -> Void) {
        invokedGetPhotoItems = true
        invokedGetPhotoItemsCount += 1
        invokedGetPhotoItemsParameters = (query, quantity)
        invokedGetPhotoItemsParametersList.append((query, quantity))
        if let result = stubbedGetPhotoItemsCompletionResult {
            completion(result.0)
        }
    }
}
