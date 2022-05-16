//
//  MockDataService.swift
//  MyChatAppTests
//
//  Created by Юрий Андрианов on 16.05.2022.
//

import Foundation
@testable import MyChatApp

final class MockDataService: IDataService {

    var invokedWriteToFile = false
    var invokedWriteToFileCount = 0
    var invokedWriteToFileParameters: (user: User, Void)?
    var invokedWriteToFileParametersList = [(user: User, Void)]()
    var stubbedWriteToFileCompletionResult: (Bool, Void)?

    func writeToFile(_ user: User, completion: @escaping ((Bool) -> Void)) {
        invokedWriteToFile = true
        invokedWriteToFileCount += 1
        invokedWriteToFileParameters = (user, ())
        invokedWriteToFileParametersList.append((user, ()))
        if let result = stubbedWriteToFileCompletionResult {
            completion(result.0)
        }
    }

    var invokedReadFromFile = false
    var invokedReadFromFileCount = 0
    var stubbedReadFromFileCompletionResult: (User?, Void)?

    func readFromFile(completion: @escaping ((User?) -> Void)) {
        invokedReadFromFile = true
        invokedReadFromFileCount += 1
        if let result = stubbedReadFromFileCompletionResult {
            completion(result.0)
        }
    }
}
