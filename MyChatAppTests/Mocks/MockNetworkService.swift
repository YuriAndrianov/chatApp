//
//  MockNetworkService.swift
//  MyChatAppTests
//
//  Created by Юрий Андрианов on 16.05.2022.
//

import Foundation
@testable import MyChatApp

final class MockNetworkService: INetworkService {

    var invokedRequest = false
    var invokedRequestCount = 0
    var invokedRequestParameters: (url: URL, Void)?
    var invokedRequestParametersList = [(url: URL, Void)]()
    var stubbedRequestCompletionResult: (Result<Data, Error>, Void)?

    func request(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        invokedRequest = true
        invokedRequestCount += 1
        invokedRequestParameters = (url, ())
        invokedRequestParametersList.append((url, ()))
        if let result = stubbedRequestCompletionResult {
            completion(result.0)
        }
    }
}
