//
//  ViewController.swift
//  MyChatApp
//
//  Created by MacBook on 23.02.2022.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private var isLargeScreenDevice: Bool {
        // check if current device is not iPhone SE (1 gen)
        return UIScreen.main.bounds.width > 375
    }
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = ThemePicker.currentTheme?.barButtonColor
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let fullNameTextField: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.font = .boldSystemFont(ofSize: 20)
        field.textColor = ThemePicker.currentTheme?.fontColor
        field.attributedPlaceholder = NSAttributedString(
            string: "Enter your name...",
            attributes: [.foregroundColor : UIColor.lightGray]
        )
        field.isEnabled = false
        field.layer.cornerRadius = 6
        field.layer.borderColor = UIColor.systemGray.cgColor
        field.translatesAutoresizingMaskIntoConstraints = false
        field.keyboardAppearance = ThemePicker.currentTheme is NightTheme ? .dark : .default
        return field
    }()
    
    private let occupationTextField: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.font = .boldSystemFont(ofSize: 15)
        field.textColor = ThemePicker.currentTheme?.fontColor
        field.attributedPlaceholder = NSAttributedString(
            string: "Enter your occupation...",
            attributes: [.foregroundColor : UIColor.lightGray]
        )
        field.isEnabled = false
        field.layer.cornerRadius = 6
        field.layer.borderColor = UIColor.systemGray.cgColor
        field.translatesAutoresizingMaskIntoConstraints = false
        field.keyboardAppearance = ThemePicker.currentTheme is NightTheme ? .dark : .default
        return field
    }()
    
    private let locationTextField: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.font = .boldSystemFont(ofSize: 15)
        field.textColor = ThemePicker.currentTheme?.fontColor
        field.attributedPlaceholder = NSAttributedString(
            string: "Enter your location...",
            attributes: [.foregroundColor : UIColor.lightGray]
        )
        field.isEnabled = false
        field.layer.cornerRadius = 6
        field.layer.borderColor = UIColor.systemGray.cgColor
        field.translatesAutoresizingMaskIntoConstraints = false
        field.keyboardAppearance = ThemePicker.currentTheme is NightTheme ? .dark : .default
        return field
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = ThemePicker.currentTheme?.saveButtonColor
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.setTitleColor(.systemGray, for: .disabled)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 8
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let saveGCDButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = ThemePicker.currentTheme?.saveButtonColor
        button.setTitle("Save GCD", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.setTitleColor(.systemGray, for: .disabled)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let saveOperationsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = ThemePicker.currentTheme?.saveButtonColor
        button.setTitle("Save Operations", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.setTitleColor(.systemGray, for: .disabled)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let editPhotoButton: UIButton = {
        let button = UIButton()
        button.tintColor = .link
        button.setBackgroundImage(UIImage(systemName: "camera.circle.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        button.addTarget(self, action: #selector(editPhotoButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let saveButtonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.alpha = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let scrollView = UIScrollView()
    
    private var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupViews()
        setConstraints()
        setDelegates()
        restoreUserData()
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
    
    private func restoreUserData() {
        DataManagerGCD.shared.readFromFile { [weak self] user in
            guard let self = self else { return }
            if let user = user {
                self.user = user
                self.fullNameTextField.text = user.fullname
                self.occupationTextField.text = user.occupation
                self.locationTextField.text = user.location
            }
        }

        ImageManager.shared.loadImageFromDiskWith(fileName: "User") { [weak self] image in
            if let image = image {
                self?.profileImageView.image = image
            } else {
                self?.profileImageView.image = UIImage(systemName: "person.circle")
            }
        }
        
        somethingIsChanged(false)
    }
    
    private func setupUIIfEditingAllowedIs(_ bool: Bool) {
        if bool {
            fullNameTextField.isEnabled = true
            occupationTextField.isEnabled = true
            locationTextField.isEnabled = true
            fullNameTextField.becomeFirstResponder()
            UIView.animate(withDuration: 0.2) {
                self.editButton.alpha = 0
                self.cancelButton.alpha = 1
                self.editPhotoButton.alpha = 1
                self.saveButtonsStack.alpha = 1
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
                self.saveButtonsStack.alpha = 0
                self.fullNameTextField.layer.borderWidth = 0
                self.occupationTextField.layer.borderWidth = 0
                self.locationTextField.layer.borderWidth = 0
            }
        }
    }
    
    private func setupNavBar() {
        title = "My Profile"
        view.backgroundColor = ThemePicker.currentTheme?.backGroundColor

        self.navigationController?.navigationBar.prefersLargeTitles = isLargeScreenDevice
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close",
                                          style: .plain,
                                          target: self,
                                          action: #selector(closeButtonTapped))
    }
    
    private func setupViews() {
        [saveGCDButton, saveOperationsButton].forEach { saveButtonsStack.addArrangedSubview($0) }
        
        [profileImageView,
         fullNameTextField,
         occupationTextField,
         locationTextField,
         cancelButton,
         saveButtonsStack,
         editButton].forEach { stackView.addArrangedSubview($0) }
        
        view.addSubview(scrollView)
        [stackView, editPhotoButton].forEach { scrollView.addSubview($0) }
    }
    
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
        restoreUserData()
        setupUIIfEditingAllowedIs(false)
        view.endEditing(true)
    }
    
    @objc private func saveButtonTapped() {
        if let image = profileImageView.image, profileImageView.image != UIImage(systemName: "person.circle") {
            ImageManager.shared.saveImage(imageName: "User", image: image)
        } else {
            ImageManager.shared.deleteImage(imageName: "User")
        }
        
        user.fullname = fullNameTextField.text
        user.occupation = occupationTextField.text
        user.location = locationTextField.text

        tryToSaveData()
        
    }
    
    private func tryToSaveData() {
        // make activity indicator
        let spinner = UIActivityIndicatorView()
        spinner.style = .large
        spinner.color = .link
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        
        // block buttons
        somethingIsChanged(false)
        cancelButton.isEnabled = false
        
        // saving to file (1 sec)
        DataManagerGCD.shared.writeToFile(user) { [weak self] success in
            // remove activity indicator
            spinner.stopAnimating()
            self?.view.endEditing(true)
            
            if success {
                // show success alert
                self?.showSaveSuccessAlert()
            } else {
                // show error alert
                self?.showSaveErrorAlert()
            }
        }
    }
    
    private func showSaveSuccessAlert() {
        let alertVC = UIAlertController(title: nil, message: "Successfully saved", preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] _ in
            self?.setupUIIfEditingAllowedIs(false)
            self?.cancelButton.isEnabled = true
        }))
        
        present(alertVC, animated: true, completion: nil)
    }
    
    private func showSaveErrorAlert() {
        let alertVC = UIAlertController(title: "Error", message: "Failed to save data" , preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] _ in
            self?.restoreUserData()
            self?.setupUIIfEditingAllowedIs(false)
            self?.cancelButton.isEnabled = true
        }))
        
        alertVC.addAction(UIAlertAction(title: "Repeat", style: .default, handler: { [weak self] _ in
            self?.tryToSaveData()
        }))
        
        present(alertVC, animated: true, completion: nil)
    }
    
    @objc private func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            
            let activeView: UIView? = [fullNameTextField, occupationTextField, locationTextField].first { $0.isFirstResponder }
            if let activeView = activeView {
                let scrollPoint = CGPoint(x: 0, y: self.view.frame.height - keyboardSize.height - activeView.frame.height - 130)
                scrollView.setContentOffset(scrollPoint, animated: true)
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification:Notification) {
        scrollView.contentInset = .zero
    }
    
    private func somethingIsChanged(_ bool: Bool) {
        if bool {
            saveGCDButton.isEnabled = true
            saveOperationsButton.isEnabled = true
        } else {
            saveGCDButton.isEnabled = false
            saveOperationsButton.isEnabled = false
        }
    }
    
    private func showAddPhotoAlertVC() {
        let alertVC = UIAlertController(title: "Choose photo from...", message: nil, preferredStyle: .actionSheet)
        
        // check if camera is available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraButton = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
                self?.showImagePicker(selectedSource: .camera)
            }
            alertVC.addAction(cameraButton)
        }
        
        let libraryButton = UIAlertAction(title: "Gallery", style: .default) { [weak self] _ in
            self?.showImagePicker(selectedSource: .photoLibrary)
        }
        alertVC.addAction(libraryButton)
        
        let deleteButton = UIAlertAction(title: "Delete photo", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.profileImageView.image = UIImage(systemName: "person.circle")
            self.somethingIsChanged(true)
        }
        
        // if there is profile photo then add delete button
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
            
            saveButtonsStack.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -10),
            
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            profileImageView.image = selectedImage
            somethingIsChanged(true)
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
        somethingIsChanged(true)
        let text = (textField.text ?? "") + string

        let result: String
        if range.length == 1 {
            let end = text.index(text.startIndex, offsetBy: text.count - 1)
            result = String(text[text.startIndex..<end])
        } else {
            result = text
        }

        textField.text = result
        
        return false
    }
 
}
