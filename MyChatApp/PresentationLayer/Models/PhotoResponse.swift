//
//  PhotoResponse.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 27.04.2022.
//

import Foundation

struct PhotoResponse: Decodable {
    
    var total: Int?
    var totalHits: Int?
    var hits: [PhotoItem]?
    
}

struct PhotoItem: Decodable {
    
    var userImageURL: String?
    
}
