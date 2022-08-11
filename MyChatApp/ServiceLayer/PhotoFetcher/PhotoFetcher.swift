//
//  PhotoFetcher.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 27.04.2022.
//

import UIKit

protocol PhotoFetching {
    
    func getPhotoItems(query: String, quantity: Int, _ completion: @escaping (Result<[PhotoItem]?, Error>) -> Void)
}

final class PhotoFetcher: PhotoFetching {
    
    private var networkService: INetworkService?
    
    init(networkService: INetworkService) {
        self.networkService = networkService
    }
    
    func getPhotoItems(
        query: String,
        quantity: Int,
        _ completion: @escaping (Result<[PhotoItem]?, Error>
        ) -> Void) {
        guard let url = PhotoAPI.getURL(with: query, quantity: quantity) else { return }
        
        networkService?.request(from: url) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    do {
                        let response = try JSONDecoder().decode(PhotoResponse.self, from: data)
                        let items = response.hits
                        completion(.success(items))
                    } catch {
                        print(error.localizedDescription)
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
        }
    }
}
