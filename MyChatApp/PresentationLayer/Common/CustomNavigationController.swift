//
//  CustomNavigationController.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 14.03.2022.
//

import UIKit

final class CustomNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let style: UIStatusBarStyle = ThemePicker.shared.currentTheme?.statusBarStyle ?? .default
        return style
    }
    
}

extension CustomNavigationController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MyCustomTransition(animationDuration: 1, animationType: .present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MyCustomTransition(animationDuration: 0.6, animationType: .dismiss)
    }
    
}
