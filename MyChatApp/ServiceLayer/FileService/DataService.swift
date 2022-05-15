//
//  DataService.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 19.03.2022.
//

import Foundation

protocol IDataService: AnyObject {
    
    func writeToFile(_ user: User, completion: @escaping ((Bool) -> Void))
    func readFromFile(completion: @escaping ((User?) -> Void))
    
}
