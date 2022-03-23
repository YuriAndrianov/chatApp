//
//  UIWindow+reload.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 13.03.2022.
//

import UIKit

public extension UIWindow {
    
    func reload() {
        subviews.forEach {
            $0.removeFromSuperview()
            addSubview($0)
        }
    }
    
}
