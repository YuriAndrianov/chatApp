//
//  LoadUserFromFileOperation.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 20.03.2022.
//

import Foundation

final class ReadFromFileOperation: Operation {
    
    var completion: ((User?) -> Void)?
    
    override func main() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            completion?(nil)
            return
        }
        let userFileURL = documentsDirectory.appendingPathComponent("user").appendingPathExtension("txt")
        do {
            let user = try JSONDecoder().decode(User.self, from: Data(contentsOf: userFileURL))
            completion?(user)
        } catch {
            completion?(nil)
            print(error)
        }
    }
    
}
