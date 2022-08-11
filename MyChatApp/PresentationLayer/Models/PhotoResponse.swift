//
//  PhotoResponse.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 27.04.2022.
//

import Foundation

struct PhotoResponse: Decodable {
    
    let hits: [PhotoItem]?
}

struct PhotoItem: Decodable {
    
    let webformatURL: String?
}
