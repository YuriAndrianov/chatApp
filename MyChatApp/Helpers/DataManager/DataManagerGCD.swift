//
//  DataManagerGCD.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 19.03.2022.
//

import Foundation

class DataManagerGCD: DataManagerProtocol {
    
    static let shared = DataManagerGCD()
    
    private init() {}
    
    func writeToFile(_ user: User, completion: @escaping ((Bool) -> Void)) {
        DispatchQueue.global(qos: .background).async {
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            let userFileURL = documentsDirectory.appendingPathComponent("user").appendingPathExtension("txt")
            print("Path to file: ", userFileURL.path)
            do {
                try JSONEncoder().encode(user).write(to: userFileURL)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    completion(true)
                })
            }
            catch {
                print(error)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    completion(false)
                })
            }
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
