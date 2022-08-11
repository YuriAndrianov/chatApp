//
//  FileManagerOperation.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 20.03.2022.
//

import Foundation

final class DataManagerOperation: IDataService {
    
    static let shared: IDataService = DataManagerOperation()
    
    private let queue = OperationQueue()
    
    private init() {}
    
    func writeToFile(_ user: User, completion: @escaping ((Bool) -> Void)) {
        let writeToFileOperation = WriteToFileOperation(user: user)
        
        writeToFileOperation.completion = { success in
            OperationQueue.main.addOperation {
                completion(success)
            }
        }
        
        queue.addOperation(writeToFileOperation)
    }
    
    func readFromFile(completion: @escaping ((User?) -> Void)) {
        let readFromFileOperation = ReadFromFileOperation()
        
        readFromFileOperation.completion = { user in
            OperationQueue.main.addOperation {
                completion(user)
            }
        }
        
        queue.addOperation(readFromFileOperation)
    }
}
