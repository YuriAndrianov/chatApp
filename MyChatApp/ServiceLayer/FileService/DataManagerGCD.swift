//
//  DataManagerGCD.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 19.03.2022.
//

import Foundation

final class DataManagerGCD: DataService {
    
    static let shared = DataManagerGCD()
    
    private init() {}
    
    func writeToFile(_ user: User, completion: @escaping ((Bool) -> Void)) {
        DispatchQueue.global(qos: .background).async {
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            let userFileURL = documentsDirectory.appendingPathComponent("user").appendingPathExtension("json")
            
            if !FileManager.default.fileExists(atPath: userFileURL.path) {
                FileManager.default.createFile(atPath: userFileURL.path, contents: nil, attributes: nil)
            }

            do {
                try JSONEncoder().encode(user).write(to: userFileURL)
                DispatchQueue.main.async { completion(true) }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async { completion(false) }
            }
        }
    }
    
    func readFromFile(completion: @escaping ((User?) -> Void)) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            completion(nil)
            return
        }
        let userFileURL = documentsDirectory.appendingPathComponent("user").appendingPathExtension("json")
        do {
            let user = try JSONDecoder().decode(User.self, from: Data(contentsOf: userFileURL))
            completion(user)
        } catch {
            completion(nil)
            print(error.localizedDescription)
        }
    }
    
}
