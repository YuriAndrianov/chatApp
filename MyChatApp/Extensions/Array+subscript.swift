//
//  Array+subscript.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 11.03.2022.
//

import Foundation

extension Array {
    public subscript(index: Int, default defaultValue: @autoclosure () -> Element) -> Element {
        guard index >= 0, index < endIndex else {
            return defaultValue()
        }

        return self[index]
    }
}
