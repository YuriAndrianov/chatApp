//
//  DataManagerOperation.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 19.03.2022.
//

import Foundation

final class DataManagerOperation: Operation, DataManagerProtocol {
    
    var inputUser: User?
    var saveToFileSuccessCompletion: ((Bool) -> Void)?
    var loadUserFromFileCompletion: ((User?) -> Void)?
    
    init(inputUser: User?) {
        self.inputUser = inputUser
        super.init()
    }
    
    override func main() {
        if let inputUser = inputUser {
            writeToFile(inputUser) { [weak self] success in
                self?.saveToFileSuccessCompletion?(success)
            }
        } else {
            readFromFile { [weak self] user in
                self?.loadUserFromFileCompletion?(user)
            }
        }
    }
    
    func writeToFile(_ user: User, completion: @escaping ((Bool) -> Void)) {
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let userFileURL = documentsDirectory.appendingPathComponent("user").appendingPathExtension("txt")
        
        if !FileManager.default.fileExists(atPath: userFileURL.path) {
            FileManager.default.createFile(atPath: userFileURL.path, contents: nil, attributes: nil)
        }
        
        print("Path to file: ", userFileURL.path)
        
        do {
            try JSONEncoder().encode(user).write(to: userFileURL)
            sleep(1)
            completion(true)
        }
        catch {
            print(error)
            sleep(1)
            completion(false)
        }
    }
    
    func readFromFile(completion: @escaping ((User?) -> Void)) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            completion(nil)
            return
        }
        let userFileURL = documentsDirectory.appendingPathComponent("user").appendingPathExtension("txt")
        do {
            let user = try JSONDecoder().decode(User.self, from: Data(contentsOf: userFileURL))
            completion(user)
        }
        catch {
            completion(nil)
            print(error)
        }
    }
    
}
