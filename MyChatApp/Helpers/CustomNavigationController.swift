//
//  CustomNavigationController.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 14.03.2022.
//

import UIKit

final class CustomNavigationController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        let style: UIStatusBarStyle = ThemePicker.currentTheme is NightTheme ? .lightContent : .darkContent
        return style
    }

}
