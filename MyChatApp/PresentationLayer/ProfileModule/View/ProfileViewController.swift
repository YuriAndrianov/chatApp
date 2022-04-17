//
//  ViewController.swift
//  MyChatApp
//
//  Created by MacBook on 23.02.2022.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private lazy var customView: MyProfileView = {
        let view = MyProfileView()
        view.editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        view.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        view.saveGCDButton.addTarget(self, action: #selector(saveGCDButtonTapped), for: .touchUpInside)
        view.editPhotoButton.addTarget(self, action: #selector(editPhotoButtonTapped), for: .touchUpInside)
        view.fullNameTextField.delegate = self
        view.occupationTextField.delegate = self
        view.locationTextField.delegate = self
        return view
    }()
    
    private var fileManager: DataService
    private var imageManager: ImageService
    private var themePicker: ThemeService
    private var user = User()
    
    private lazy var isSomethingChanged = false {
        didSet {
            customView.saveGCDButton.isEnabled = isSomethingChanged ? true : false
        }
    }
    
    init(with fileManager: DataService, imageManager: ImageService, themePicker: ThemeService) {
        self.fileManager = fileManager
        self.imageManager = imageManager
        self.themePicker = themePicker
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.fileManager = DataManagerGCD.shared
        self.imageManager = ImageManager.shared
        self.themePicker = ThemePicker.shared
        super.init(coder: coder)
    }
    
    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        restoreUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerObservers()
    }
    
    override func viewDidLayoutSubviews() {
        customView.scrollView.frame = view.bounds
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
    
    private func restoreUserData() {
        fileManager.readFromFile { [weak self] user in
            guard let self = self else { return }
            if let user = user {
                self.user = user
                self.customView.fullNameTextField.text = user.fullname
                self.customView.occupationTextField.text = user.occupation
                self.customView.locationTextField.text = user.location
            }
        }
        
        imageManager.loadImageFromDiskWith(fileName: "User") { [weak self] image in
            guard let self = self else { return }
            if let image = image {
                self.customView.profileImageView.image = image
            } else {
                self.customView.profileImageView.image = UIImage(systemName: "person.circle")
            }
        }
        
        isSomethingChanged = false
    }
    
    private func setupUIIfEditingAllowedIs(_ bool: Bool) {
        customView.setupUIIfEditingAllowedIs(bool)
    }
    
    private func setupNavBar() {
        title = "My Profile"
        view.backgroundColor = themePicker.currentTheme?.backgroundColor
        
        self.navigationController?.navigationBar.prefersLargeTitles = customView.isLargeScreenDevice
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(closeButtonTapped))
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            customView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            
            let activeView: UIView? = [customView.fullNameTextField, customView.occupationTextField, customView.locationTextField].first { $0.isFirstResponder }
            if let activeView = activeView {
                let scrollPoint = CGPoint(x: 0, y: self.view.frame.height - keyboardSize.height - activeView.frame.height - 130)
                customView.scrollView.setContentOffset(scrollPoint, animated: true)
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        customView.scrollView.contentInset = .zero
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
        restoreUserData()
        setupUIIfEditingAllowedIs(false)
        view.endEditing(true)
    }
    
    @objc private func saveGCDButtonTapped() {
        // saving image
        if let image = customView.profileImageView.image,
            customView.profileImageView.image != UIImage(systemName: "person.circle") {
            imageManager.saveImage(imageName: "User", image: image)
        } else {
            imageManager.deleteImage(imageName: "User")
        }
        
        // adding properties to self.user from textfields
        user.fullname = customView.fullNameTextField.text
        user.occupation = customView.occupationTextField.text
        user.location = customView.locationTextField.text

        tryToSaveData()
    }
    
    private func tryToSaveData() {
        // make activity indicator
        let spinner = customView.createSpinner()
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        
        // block buttons and fields
        isSomethingChanged = false
        customView.cancelButton.isEnabled = false
        customView.fullNameTextField.isEnabled = false
        customView.occupationTextField.isEnabled = false
        customView.locationTextField.isEnabled = false
        
        // saving to file
        fileManager.writeToFile(user) { [weak self] success in
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
            self.customView.cancelButton.isEnabled = true
        }))
        
        present(alertVC, animated: true, completion: nil)
    }
    
    private func showSaveErrorAlert() {
        let alertVC = UIAlertController(title: "Error", message: "Failed to save data", preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] _ in
            guard let self = self else { return }
            self.restoreUserData()
            self.setupUIIfEditingAllowedIs(false)
            self.customView.cancelButton.isEnabled = true
        }))
        
        alertVC.addAction(UIAlertAction(title: "Repeat", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.tryToSaveData()
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
            self.customView.profileImageView.image = UIImage(systemName: "person.circle")
            self.isSomethingChanged = true
        }
        
        // if there is a profile photo then add a delete button
        if customView.profileImageView.image != UIImage(systemName: "person.circle") {
            alertVC.addAction(deleteButton)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(cancelButton)
        
        present(alertVC, animated: true, completion: nil)
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
            customView.profileImageView.image = selectedImage
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
