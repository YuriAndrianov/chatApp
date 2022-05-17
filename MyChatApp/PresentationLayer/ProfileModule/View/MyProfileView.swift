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
    
    var shouldAnimateEditPhotoButton = false {
        didSet { shouldAnimateEditPhotoButton ? startAnimation() : stopAnimation() }
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
        let profileImageWidth: CGFloat = UIScreen.main.isLargeScreenDevice ? 220 : 150
        let editPhotoButtonWidth: CGFloat = UIScreen.main.isLargeScreenDevice ? 50 : 30
        
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
    
    func blockButtonsAndFields() {
        saveGCDButton.isEnabled = false
        cancelButton.isEnabled = false
        fullNameTextField.isEnabled = false
        occupationTextField.isEnabled = false
        locationTextField.isEnabled = false
    }
    
    func setup(editingAllowed isAllowed: Bool) {
        // Turns true when edit button tapped and false when save button tapped
        let isOn: CGFloat = isAllowed ? 1 : 0
        let isOff: CGFloat = isAllowed ? 0 : 1
        
        fullNameTextField.isEnabled = isAllowed
        occupationTextField.isEnabled = isAllowed
        locationTextField.isEnabled = isAllowed
        fullNameTextField.becomeFirstResponder()
        
        UIView.animate(withDuration: 0.2) {
            self.editButton.alpha = isOff
            self.cancelButton.alpha = isOn
            self.editPhotoButton.alpha = isOn
            self.saveGCDButton.alpha = isOn
            self.fullNameTextField.layer.borderWidth = isOn
            self.occupationTextField.layer.borderWidth = isOn
            self.locationTextField.layer.borderWidth = isOn
        }
    }
    
    private func startAnimation() {
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.toValue = NSNumber(value: Double.pi / 10)
        rotate.fromValue = NSNumber(value: -Double.pi / 10)
        
        let shakeX = CABasicAnimation(keyPath: "position.x")
        shakeX.toValue = editPhotoButton.layer.position.x + 5
        shakeX.fromValue = editPhotoButton.layer.position.x - 5
        
        let shakeY = CABasicAnimation(keyPath: "position.y")
        shakeY.toValue = editPhotoButton.layer.position.y - 5
        shakeY.fromValue = editPhotoButton.layer.position.y + 5
        
        let group = CAAnimationGroup()
        group.duration = 0.3
        group.repeatCount = .infinity
        group.autoreverses = true
        group.isRemovedOnCompletion = true
        group.animations = [rotate, shakeX, shakeY]
        
        editPhotoButton.layer.add(group, forKey: nil)
    }
    
    private func stopAnimation() {
        let stopRotate = CABasicAnimation(keyPath: "transform.rotation.z")
        stopRotate.toValue = NSNumber(value: 0)
        stopRotate.fromValue = editPhotoButton.layer.zPosition
        
        let stopShakeX = CABasicAnimation(keyPath: "position.x")
        stopShakeX.toValue = editPhotoButton.center.x
        stopShakeX.fromValue = editPhotoButton.layer.position.x
        
        let stopShakeY = CABasicAnimation(keyPath: "position.y")
        stopShakeY.toValue = editPhotoButton.center.y
        stopShakeY.fromValue = editPhotoButton.layer.position.y
        
        let stopGroup = CAAnimationGroup()
        stopGroup.duration = 5
        stopGroup.repeatCount = .infinity
        stopGroup.isRemovedOnCompletion = true
        stopGroup.animations = [stopRotate, stopShakeX, stopShakeY]
        
        editPhotoButton.layer.add(stopGroup, forKey: nil)
    }
    
}
