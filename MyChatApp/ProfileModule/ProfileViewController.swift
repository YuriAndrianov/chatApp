//
//  ViewController.swift
//  MyChatApp
//
//  Created by MacBook on 23.02.2022.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let styleSheet = ProfileVCStyleSheet()
    private let scrollView = UIScrollView()
    
    private var user = User()
    
    private var isLargeScreenDevice: Bool {
        // check if current device is not iPhone SE (1 gen)
        return UIScreen.main.bounds.width > 375
    }
    
    private lazy var profileImageView: UIImageView = {
        let imageView = styleSheet.createProfileImageView()
        return imageView
    }()
    
    private lazy var fullNameTextField: UITextField = {
        let field = styleSheet.createFullNameTextField()
        return field
    }()
    
    private lazy var occupationTextField: UITextField = {
        let field = styleSheet.createSecondaryTextField("Enter your occupation...")
        return field
    }()
    
    private lazy var locationTextField: UITextField = {
        let field = styleSheet.createSecondaryTextField("Enter your location...")
        return field
    }()
    
    private lazy var editButton: UIButton = {
        let button = styleSheet.createEditButton()
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = styleSheet.createCancelButton()
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveGCDButton: UIButton = {
        let button = styleSheet.createSaveButton(withTitle: "Save")
        button.addTarget(self, action: #selector(saveGCDButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var editPhotoButton: UIButton = {
        let button = styleSheet.createEditPhotoButton()
        button.addTarget(self, action: #selector(editPhotoButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = styleSheet.createMainStackView()
        return stackView
    }()
    
    private lazy var isSomethingChanged = false {
        didSet {
            saveGCDButton.isEnabled = isSomethingChanged ? true : false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupViews()
        setConstraints()
        setDelegates()
        restoreUserDataUsing(manager: DataManagerGCD.shared)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerObservers()
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.frame = view.bounds
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func registerObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func setDelegates() {
        fullNameTextField.delegate = self
        occupationTextField.delegate = self
        locationTextField.delegate = self
    }
    
    private func restoreUserDataUsing(manager: DataManagerProtocol) {
        manager.readFromFile { [weak self] user in
            guard let self = self else { return }
            if let user = user {
                self.user = user
                self.fullNameTextField.text = user.fullname
                self.occupationTextField.text = user.occupation
                self.locationTextField.text = user.location
            }
        }
        
        ImageManager.shared.loadImageFromDiskWith(fileName: "User") { [weak self] image in
            guard let self = self else { return }
            if let image = image {
                self.profileImageView.image = image
            } else {
                self.profileImageView.image = UIImage(systemName: "person.circle")
            }
        }
        
        isSomethingChanged = false
    }
    
    private func setupUIIfEditingAllowedIs(_ bool: Bool) {
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
    
    private func setupNavBar() {
        title = "My Profile"
        view.backgroundColor = ThemePicker.shared.currentTheme?.backgroundColor
        
        self.navigationController?.navigationBar.prefersLargeTitles = isLargeScreenDevice
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(closeButtonTapped))
    }
    
    private func setupViews() {
        [
            profileImageView,
            fullNameTextField,
            occupationTextField,
            locationTextField,
            cancelButton,
            saveGCDButton,
            editButton
        ].forEach { stackView.addArrangedSubview($0) }
        
        view.addSubview(scrollView)
        [stackView, editPhotoButton].forEach { scrollView.addSubview($0) }
    }
//
//    private func somethingIsChanged(_ bool: Bool) {
//        // Turns true if user typed or deleted any character or changed photo
//        saveGCDButton.isEnabled = bool ? true : false
//    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            
            let activeView: UIView? = [fullNameTextField, occupationTextField, locationTextField].first { $0.isFirstResponder }
            if let activeView = activeView {
                let scrollPoint = CGPoint(x: 0, y: self.view.frame.height - keyboardSize.height - activeView.frame.height - 130)
                scrollView.setContentOffset(scrollPoint, animated: true)
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = .zero
    }
    
    // MARK: - Button's methods
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func editPhotoButtonTapped() {
        showAddPhotoAlertVC()
    }
    
    @objc private func editButtonTapped() {
        setupUIIfEditingAllowedIs(true)
    }
    
    @objc private func doneButtonTapped() {
        view.endEditing(true)
    }
    
    @objc private func cancelButtonTapped() {
        restoreUserDataUsing(manager: DataManagerGCD.shared)
        setupUIIfEditingAllowedIs(false)
        view.endEditing(true)
    }
    
    @objc private func saveGCDButtonTapped() {
        // saving image
        if let image = profileImageView.image, profileImageView.image != UIImage(systemName: "person.circle") {
            ImageManager.shared.saveImage(imageName: "User", image: image)
        } else {
            ImageManager.shared.deleteImage(imageName: "User")
        }
        
        // adding properties to self.user from textfields
        user.fullname = fullNameTextField.text
        user.occupation = occupationTextField.text
        user.location = locationTextField.text

        tryToSaveDataUsing(manager: DataManagerGCD.shared)
    }
    
    private func tryToSaveDataUsing(manager: DataManagerProtocol) {
        // make activity indicator
        let spinner = styleSheet.createSpinner()
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        
        // block buttons and fields
        isSomethingChanged = false
        cancelButton.isEnabled = false
        fullNameTextField.isEnabled = false
        occupationTextField.isEnabled = false
        locationTextField.isEnabled = false
        
        // saving to file
        manager.writeToFile(user) { [weak self] success in
            guard let self = self else { return }
            // remove activity indicator
            spinner.stopAnimating()
            self.view.endEditing(true)
            
            if success {
                // show success alert
                self.showSaveSuccessAlert()
            } else {
                // show error alert
                self.showSaveErrorAlert()
            }
        }
    }
    // MARK: - Methods showing alert VC's
    
    private func showSaveSuccessAlert() {
        let alertVC = UIAlertController(title: nil, message: "Successfully saved", preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] _ in
            guard let self = self else { return }
            self.setupUIIfEditingAllowedIs(false)
            self.cancelButton.isEnabled = true
        }))
        
        present(alertVC, animated: true, completion: nil)
    }
    
    private func showSaveErrorAlert() {
        let alertVC = UIAlertController(title: "Error", message: "Failed to save data", preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] _ in
            guard let self = self else { return }
            self.restoreUserDataUsing(manager: DataManagerGCD.shared)
            self.setupUIIfEditingAllowedIs(false)
            self.cancelButton.isEnabled = true
        }))
        
        alertVC.addAction(UIAlertAction(title: "Repeat", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.tryToSaveDataUsing(manager: DataManagerGCD.shared)
        }))
        
        present(alertVC, animated: true, completion: nil)
    }
    
    private func showAddPhotoAlertVC() {
        let alertVC = UIAlertController(title: "Choose photo from...", message: nil, preferredStyle: .actionSheet)
        
        // check if camera is available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraButton = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.showImagePicker(selectedSource: .camera)
            }
            alertVC.addAction(cameraButton)
        }
        
        let libraryButton = UIAlertAction(title: "Gallery", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.showImagePicker(selectedSource: .photoLibrary)
        }
        alertVC.addAction(libraryButton)
        
        let deleteButton = UIAlertAction(title: "Delete photo", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.profileImageView.image = UIImage(systemName: "person.circle")
            self.isSomethingChanged = true
        }
        
        // if there is a profile photo then add a delete button
        if profileImageView.image != UIImage(systemName: "person.circle") {
            alertVC.addAction(deleteButton)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(cancelButton)
        
        present(alertVC, animated: true, completion: nil)
    }
}
// MARK: - Constraints

extension ProfileViewController {
    
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
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
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
    
}
// MARK: - Delegates

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePicker(selectedSource: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(selectedSource) else { return }
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = selectedSource
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            profileImageView.image = selectedImage
            isSomethingChanged = true
        }
        picker.dismiss(animated: true)
    }
    
}

extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        isSomethingChanged = true
        let text = (textField.text ?? "") + string
        
        let result: String
        if range.length == 1 {
            let end = text.index(text.startIndex, offsetBy: text.count - 1)
            result = String(text[text.startIndex..<end])
        } else { result = text }
        
        textField.text = result
        return false
    }
    
}
