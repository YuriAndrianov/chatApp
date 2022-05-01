//
//  CustomError.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 27.04.2022.
//

import Foundation

enum CustomError: Error {
    
    case noData
    case noInternet
    case unknownErr
    
}

extension CustomError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .noData:
            return "Couldn't fetch photos"
        case .noInternet:
            return "No internet connection"
        case .unknownErr:
            return "Something went wrong"
        }
    }
    
}
