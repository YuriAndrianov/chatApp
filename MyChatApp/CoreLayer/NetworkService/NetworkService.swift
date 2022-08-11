//
//  NetworkService.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 05.05.2022.
//

import Foundation

final class NetworkService: INetworkService {
    
    func request(from url: URL, _ completion: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        guard let dataTask = createDataTask(from: request, completion: completion) else {
            let noConnectionError = NetworkError.noInternet
            
            DispatchQueue.main.async { completion(.failure(noConnectionError)) }
            
            return
        }
        dataTask.resume()
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask? {
        return URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            
            guard let data = data else {
                let noDataError = NetworkError.noData
                
                DispatchQueue.main.async { completion(.failure(noDataError)) }
                
                return
            }
            DispatchQueue.main.async { completion(.success(data)) }
        }
    }
    
}
