//
//  StyleSheet.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 20.03.2022.
//

import UIKit

final class ProfileVCStyleSheet {
    
    private var currentTheme: ITheme? {
        return ThemePicker.shared.currentTheme
    }
    
    func createProfileImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = currentTheme?.barButtonColor
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    func createFullNameTextField() -> UITextField {
        let field = UITextField()
        field.textAlignment = .center
        field.font = .boldSystemFont(ofSize: 20)
        field.textColor = currentTheme?.fontColor
        field.attributedPlaceholder = NSAttributedString(
            string: "Enter your name...",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        field.isEnabled = false
        field.layer.cornerRadius = 6
        field.layer.borderColor = UIColor.systemGray.cgColor
        field.translatesAutoresizingMaskIntoConstraints = false
        field.keyboardAppearance = currentTheme is NightTheme ? .dark : .default
        return field
    }
    
    func createSecondaryTextField(_ text: String) -> UITextField {
        let field = UITextField()
        field.textAlignment = .center
        field.font = .boldSystemFont(ofSize: 15)
        field.textColor = currentTheme?.fontColor
        field.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        field.isEnabled = false
        field.layer.cornerRadius = 6
        field.layer.borderColor = UIColor.systemGray.cgColor
        field.translatesAutoresizingMaskIntoConstraints = false
        field.keyboardAppearance = currentTheme is NightTheme ? .dark : .default
        return field
    }
    
    func createEditButton() -> UIButton {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func createCancelButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = currentTheme?.saveButtonColor
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.setTitleColor(.systemGray, for: .disabled)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 8
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func createSaveButton(withTitle: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = currentTheme?.saveButtonColor
        button.setTitle(withTitle, for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.setTitleColor(.systemGray, for: .disabled)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.alpha = 0
        button.layer.cornerRadius = 8
        return button
    }
    
    func createEditPhotoButton() -> UIButton {
        let button = UIButton()
        button.tintColor = .link
        button.setBackgroundImage(UIImage(systemName: "camera.circle.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        return button
    }
    
    func createMainStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    func createSpinner() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView()
        spinner.style = .large
        spinner.color = .link
        spinner.hidesWhenStopped = true
        return spinner
    }
    
}
