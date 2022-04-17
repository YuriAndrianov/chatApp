//
//  Array+subscript.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 11.03.2022.
//

import Foundation

extension Array {
    subscript (safeIndex index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
