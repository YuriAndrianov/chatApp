//
//  DebugOptions.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 03.04.2022.
//

import Foundation

func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
#if DEBUG
    items.forEach {
        Swift.print($0, separator: separator, terminator: terminator)
    }
#endif
}
