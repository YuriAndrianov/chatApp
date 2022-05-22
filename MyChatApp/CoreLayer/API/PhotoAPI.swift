//
//  PhotoAPI.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 21.05.2022.
//

import Foundation

struct PhotoAPI {
    
    static func getURL(with query: String, quantity: Int = 200) -> URL? {
        guard
            var urlComponents = URLComponents(string: "https://pixabay.com"),
            let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String
        else {
            return nil
        }
        
        let params = [
            "image_type": "photo",
            "q": query,
            "key": apiKey,
            "per_page": "\(quantity)"
        ]
        
        urlComponents.path = "/api"
        urlComponents.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        
        return urlComponents.url
    }
}
