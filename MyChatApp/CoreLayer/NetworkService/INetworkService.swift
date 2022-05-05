//
//  INetworkService.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 27.04.2022.
//

import Foundation

protocol Networking {
    
    func request(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
    
}
