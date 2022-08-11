//
//  UIScreen+isLargeScreenDevice.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 04.05.2022.
//

import UIKit

extension UIScreen {
    
    static var isLargeScreenDevice: Bool {
        return UIScreen.main.nativeBounds.height > 1136
    }
}
