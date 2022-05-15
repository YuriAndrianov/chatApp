//
//  UIScreen+isLargeScreenDevice.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 04.05.2022.
//

import UIKit

extension UIScreen {
    
    var isLargeScreenDevice: Bool {
        return UIScreen.main.bounds.width > 375
    }
    
}
