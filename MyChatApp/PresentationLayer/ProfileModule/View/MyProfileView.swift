//
//  MyProfileView.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 17.04.2022.
//

import UIKit

final class MyProfileView: UIView {
    
    private let styleSheet = ProfileVCStyleSheet()
    let scrollView = UIScrollView()
    
    var isLargeScreenDevice: Bool {
        // check if current device is not iPhone SE (1 gen)
        return UIScreen.main.bounds.width > 375
    }
    
    lazy var profileImageView: UIImageView = {
        let imageView = styleSheet.createProfileImageView()
        return imageView
    }()
    
    lazy var fullNameTextField: UITextField = {
        let field = styleSheet.createFullNameTextField()
        return field
    }()
    
    lazy var occupationTextField: UITextField = {
        let field = styleSheet.createSecondaryTextField("Enter your occupation...")
        return field
    }()
    
    lazy var locationTextField: UITextField = {
        let field = styleSheet.createSecondaryTextField("Enter your location...")
        return field
    }()
    
    lazy var editButton: UIButton = {
        return styleSheet.createEditButton()
    }()
    
    lazy var cancelButton: UIButton = {
        return styleSheet.createCancelButton()
    }()
    
    lazy var saveGCDButton: UIButton = {
        return styleSheet.createSaveButton(withTitle: "Save")
    }()

    lazy var editPhotoButton: UIButton = {
        return styleSheet.createEditPhotoButton()
    }()
    
    lazy var stackView: UIStackView = {
        return styleSheet.createMainStackView()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        [
            profileImageView,
            fullNameTextField,
            occupationTextField,
            locationTextField,
            cancelButton,
            saveGCDButton,
            editButton
        ].forEach { stackView.addArrangedSubview($0) }
        
        addSubview(scrollView)
        [stackView, editPhotoButton].forEach { scrollView.addSubview($0) }
        
        setConstraints()
    }
    
    private func setConstraints() {
        var profileImageWidth: CGFloat = 220
        var editPhotoButtonWidth: CGFloat = 50
        
        if !isLargeScreenDevice {
            profileImageWidth = 150
            editPhotoButtonWidth = 30
        }
        
        profileImageView.layer.cornerRadius = profileImageWidth / 2
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.widthAnchor.constraint(equalTo: widthAnchor, constant: -60),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -30),
            
            profileImageView.widthAnchor.constraint(equalToConstant: profileImageWidth),
            profileImageView.heightAnchor.constraint(equalToConstant: profileImageWidth),
            
            fullNameTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -10),
            fullNameTextField.heightAnchor.constraint(equalToConstant: 24),
            
            occupationTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -10),
            occupationTextField.heightAnchor.constraint(equalToConstant: 24),
            
            locationTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -10),
            locationTextField.heightAnchor.constraint(equalToConstant: 24),
            
            editButton.widthAnchor.constraint(equalToConstant: 40),
            editButton.heightAnchor.constraint(equalToConstant: 40),
            
            saveGCDButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -10),
            
            cancelButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -10),
            
            editPhotoButton.widthAnchor.constraint(equalToConstant: editPhotoButtonWidth),
            editPhotoButton.heightAnchor.constraint(equalToConstant: editPhotoButtonWidth),
            editPhotoButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor),
            editPhotoButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor)
        ])
    }
    
    func createSpinner() -> UIActivityIndicatorView {
        return styleSheet.createSpinner()
    }
    
    func setupUIIfEditingAllowedIs(_ bool: Bool) {
        // Turns true when edit button tapped and false when save button tapped
        if bool {
            fullNameTextField.isEnabled = true
            occupationTextField.isEnabled = true
            locationTextField.isEnabled = true
            fullNameTextField.becomeFirstResponder()
            UIView.animate(withDuration: 0.2) {
                self.editButton.alpha = 0
                self.cancelButton.alpha = 1
                self.editPhotoButton.alpha = 1
                self.saveGCDButton.alpha = 1
                self.fullNameTextField.layer.borderWidth = 1
                self.occupationTextField.layer.borderWidth = 1
                self.locationTextField.layer.borderWidth = 1
            }
        } else {
            fullNameTextField.isEnabled = false
            occupationTextField.isEnabled = false
            locationTextField.isEnabled = false
            UIView.animate(withDuration: 0.2) {
                self.editButton.alpha = 1
                self.cancelButton.alpha = 0
                self.editPhotoButton.alpha = 0
                self.saveGCDButton.alpha = 0
                self.fullNameTextField.layer.borderWidth = 0
                self.occupationTextField.layer.borderWidth = 0
                self.locationTextField.layer.borderWidth = 0
            }
        }
    }
    
    func blockButtons() {
        
    }
    
}
