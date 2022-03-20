//
//  WriteUserToFileOperation.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 20.03.2022.
//

import Foundation

final class WriteToFileOperation: Operation {
    
    var user: User?
    
    var completion: ((Bool) -> Void)?
    
    init(user: User?) {
        self.user = user
        super.init()
    }
    
    override func main() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let userFileURL = documentsDirectory.appendingPathComponent("user").appendingPathExtension("txt")
        
        if !FileManager.default.fileExists(atPath: userFileURL.path) {
            FileManager.default.createFile(atPath: userFileURL.path, contents: nil, attributes: nil)
        }
        
        print("Path to file: ", userFileURL.path)
        
        do {
            try JSONEncoder().encode(user).write(to: userFileURL)
            sleep(1)
            completion?(true)
        }
        catch {
            print(error)
            sleep(1)
            completion?(false)
        }
    }
    
}
