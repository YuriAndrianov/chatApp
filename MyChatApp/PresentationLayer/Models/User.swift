//
//  User.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 19.03.2022.
//

import Foundation
import UIKit

class User: Codable {
    
    var fullname: String?
    var occupation: String?
    var location: String?
    var preferedTheme: String?
    
    static let userId = UIDevice.current.identifierForVendor?.uuidString ?? ""
    
}
