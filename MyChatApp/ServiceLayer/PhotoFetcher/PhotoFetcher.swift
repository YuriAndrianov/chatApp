//
//  PhotoFetcher.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 27.04.2022.
//

import UIKit

protocol PhotoFetching {
    
    func getPhotoItems(_ completion: @escaping (Result<[PhotoItem]?, Error>) -> Void)
    
}

final class PhotoFetcher: PhotoFetching {
    
    private var networkService: Networking?
    
    init(networkService: Networking) {
        self.networkService = networkService
    }
    
    func getPhotoItems(_ completion: @escaping (Result<[PhotoItem]?, Error>) -> Void) {
        guard let url = URL(
            string: "https://pixabay.com/api/?key=27030980-c7535c65d84b7a9bcae7e1ad1&q=face&image_type=photo&per_page=200"
        ) else { return }
        
        networkService?.request(from: url, completion: { result in
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
        })
    }
    
}
