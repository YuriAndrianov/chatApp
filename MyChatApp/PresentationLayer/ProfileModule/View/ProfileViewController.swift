//
//  ViewController.swift
//  MyChatApp
//
//  Created by MacBook on 23.02.2022.
//

import UIKit

final class ProfileViewController: LogoAnimatableViewController, IProfileView {
    
    var presenter: IProfilePresenter?
    
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
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        presenter?.onViewDidLoad()
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
    
    func configureUIWith(_ user: User) {
        customView.fullNameTextField.text = user.fullname
        customView.occupationTextField.text = user.occupation
        customView.locationTextField.text = user.location
    }
    
    func setUserImage(_ image: UIImage?) {
        customView.saveGCDButton.isEnabled = true
        customView.shouldAnimateEditPhotoButton = false
        customView
            .profileImageView
            .image = image != nil ? image : UIImage(systemName: "person.circle")
    }
    
    func setNewPhoto(_ url: String) {
        presenter?.setNewPhoto(url)
    }
    
    func disableSaveButton() {
        customView.saveGCDButton.isEnabled = false
    }
    
    private func setupNavBar() {
        title = "My Profile"
        view.backgroundColor = presenter?.themePicker.currentTheme?.backgroundColor
        
        navigationController?.navigationBar.prefersLargeTitles = UIScreen.main.isLargeScreenDevice
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close",
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
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func editPhotoButtonTapped() {
        customView.shouldAnimateEditPhotoButton = true
        showAddPhotoAlertVC()
    }
    
    @objc private func editButtonTapped() {
        customView.setup(editingAllowed: true)
    }
    
    @objc private func doneButtonTapped() {
        view.endEditing(true)
    }
    
    @objc private func cancelButtonTapped() {
        presenter?.onViewDidLoad()
        customView.shouldAnimateEditPhotoButton = false
        customView.setup(editingAllowed: false)
        view.endEditing(true)
    }
    
    @objc private func saveGCDButtonTapped() {
        // saving image
        if let image = customView.profileImageView.image,
           customView.profileImageView.image != UIImage(systemName: "person.circle") {
            presenter?.saveImage(imageName: "User", image: image)
        } else {
            presenter?.deleteImage(imageName: "User")
        }
        
        presenter?.userInfoDidEnter(fullname: customView.fullNameTextField.text,
                                    occupation: customView.occupationTextField.text,
                                    location: customView.locationTextField.text)
        
        tryToSaveData()
    }
    
    private func tryToSaveData() {
        // make activity indicator
        let spinner = customView.createSpinner()
        spinner.center = view.center
        spinner.startAnimating()
        view.addSubview(spinner)
        
        // block buttons and fields
        customView.blockButtonsAndFields()
        
        // saving to file
        presenter?.saveUser { [weak self] success in
            // remove activity indicator
            spinner.stopAnimating()
            self?.view.endEditing(true)
            
            success ? self?.showSaveSuccessAlert() : self?.showSaveErrorAlert()
        }
    }
    // MARK: - Methods showing alert VC's
    
    private func showSaveSuccessAlert() {
        let alertVC = UIAlertController(title: nil, message: "Successfully saved", preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel) { [weak self] _ in
            self?.customView.setup(editingAllowed: false)
            self?.customView.cancelButton.isEnabled = true
        })
        
        present(alertVC, animated: true, completion: nil)
    }
    
    private func showSaveErrorAlert() {
        let alertVC = UIAlertController(title: "Error", message: "Failed to save data", preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel) { [weak self] _ in
            self?.presenter?.onViewDidLoad()
            self?.customView.saveGCDButton.isEnabled = false
            self?.customView.setup(editingAllowed: false)
            self?.customView.cancelButton.isEnabled = true
        })
        
        alertVC.addAction(UIAlertAction(title: "Repeat", style: .default) { [weak self] _ in
            self?.tryToSaveData()
        })
        
        present(alertVC, animated: true, completion: nil)
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
        
        let networkButton = UIAlertAction(title: "Find in network...", style: .default) { [weak self] _ in
            self?.networkPickerButtonTapped()
        }
        alertVC.addAction(networkButton)
        
        let deleteButton = UIAlertAction(title: "Delete photo", style: .destructive) { [weak self] _ in
            self?.customView.profileImageView.image = UIImage(systemName: "person.circle")
            self?.customView.saveGCDButton.isEnabled = true
            self?.customView.shouldAnimateEditPhotoButton = false
        }
        
        // if there is a profile photo then add a delete button
        if customView.profileImageView.image != UIImage(systemName: "person.circle") {
            alertVC.addAction(deleteButton)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.customView.shouldAnimateEditPhotoButton = false
        }
        alertVC.addAction(cancelButton)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    func networkPickerButtonTapped() {
        presenter?.networkPickerButtonTapped()
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
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.editedImage] as? UIImage { setUserImage(selectedImage) }
        picker.dismiss(animated: true)
    }
    
}

extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        customView.saveGCDButton.isEnabled = true
        
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
