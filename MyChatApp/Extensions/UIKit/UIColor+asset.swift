//
//  UIColor+asset.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 23.03.2022.
//

import UIKit

extension UIColor {

    static func asset(named name: String) -> UIColor {
        guard let color = UIColor(named: name) else {
            fatalError("No such color in assets")
        }

        return color
    }
}
