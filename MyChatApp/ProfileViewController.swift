//
//  ViewController.swift
//  MyChatApp
//
//  Created by MacBook on 23.02.2022.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .systemGray
        imageView.layer.cornerRadius = 110
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let fullNameTextField: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.placeholder = "Enter your name..."
        field.font = .boldSystemFont(ofSize: 24)
        field.isEnabled = false
        field.layer.cornerRadius = 6
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let userInfoTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .center
        textView.font = .systemFont(ofSize: 16)
        textView.textContainer.maximumNumberOfLines = 3
        textView.layer.cornerRadius = 6
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
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
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "saveButtonColor")
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 19)
        button.layer.cornerRadius = 12
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupViews()
        setConstraints()
        setDelegates()
        createToolBar()
        setupTextInfo()
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
        userInfoTextView.delegate = self
    }
    
    private func createToolBar() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                        target: nil,
                                        action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel",
                                           style: UIBarButtonItem.Style.plain,
                                           target: self,
                                           action: #selector(cancelButtonTapped))
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .done,
                                         target: self,
                                         action: #selector(doneButtonTapped))
        toolbar.items = [cancelButton, flexSpace, doneButton]
        
        fullNameTextField.inputAccessoryView = toolbar
        userInfoTextView.inputAccessoryView = toolbar
    }
    
    private func setupTextInfo() {
        fullNameTextField.text = UserDefaults.standard.string(forKey: "fullnameText")
        
        // creating "placeholder" of textview
        if let text =  UserDefaults.standard.string(forKey: "userInfoText"),
           text != "Enter short info about you..." {
            userInfoTextView.text = text
            userInfoTextView.textColor = UIColor.black
        } else {
            userInfoTextView.text = "Enter short info about you..."
            userInfoTextView.textColor = UIColor.lightGray
        }
    }
    
    private func setupUIIfEditingAllowedIs(_ bool: Bool) {
        if bool {
            fullNameTextField.isEnabled = true
            fullNameTextField.becomeFirstResponder()
            userInfoTextView.isEditable = true
            userInfoTextView.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.2) {
                self.editButton.alpha = 0
                self.editPhotoButton.alpha = 1
                self.saveButton.alpha = 1
                self.fullNameTextField.backgroundColor = .secondarySystemBackground
                self.userInfoTextView.backgroundColor = .secondarySystemBackground
            }
        } else {
            fullNameTextField.isEnabled = false
            userInfoTextView.isEditable = false
            userInfoTextView.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.2) {
                self.editButton.alpha = 1
                self.editPhotoButton.alpha = 0
                self.saveButton.alpha = 0
                self.fullNameTextField.backgroundColor = .systemBackground
                self.userInfoTextView.backgroundColor = .systemBackground
            }
        }
    }
    
    private func setupNavBar() {
        title = "My Profile"
        view.backgroundColor = .systemBackground
        
        // check if current device is iPhone SE (1 gen)
        if UIScreen.main.bounds.width > 375 {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        self.navigationController?.navigationBar.backgroundColor = UIColor(named: "navBarBackgroundColor")
        
        let closeButton = UIBarButtonItem(title: "Close",
                                          style: .plain,
                                          target: self,
                                          action: #selector(closeButtonTapped))
        
        self.navigationItem.rightBarButtonItem = closeButton
        
    }
    
    private func setupViews() {
        [profileImageView, fullNameTextField, userInfoTextView, editButton].forEach { stackView.addArrangedSubview($0) }
        view.addSubview(scrollView)
        [stackView, saveButton, editPhotoButton].forEach { scrollView.addSubview($0) }
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
        fullNameTextField.text = UserDefaults.standard.string(forKey: "fullnameText")
        userInfoTextView.text = UserDefaults.standard.string(forKey: "userInfoText")
        view.endEditing(true)
    }
    
    @objc private func saveButtonTapped() {
        UserDefaults.standard.set(fullNameTextField.text, forKey: "fullnameText")
        UserDefaults.standard.set(userInfoTextView.text, forKey: "userInfoText")
        setupUIIfEditingAllowedIs(false)
    }
    
    @objc private func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            
            let activeView: UIView? = [fullNameTextField, userInfoTextView].first { $0.isFirstResponder }
            if let activeView = activeView {
                let scrollPoint = CGPoint(x: 0, y: self.view.frame.height - keyboardSize.height - activeView.frame.height - 30)
                scrollView.setContentOffset(scrollPoint, animated: true)
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification:Notification) {
        scrollView.contentInset = .zero
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
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(cancelButton)
        
        present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - Constraints
extension ProfileViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            profileImageView.widthAnchor.constraint(equalToConstant: 220),
            profileImageView.heightAnchor.constraint(equalToConstant: 220),
            
            fullNameTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -10),
            fullNameTextField.heightAnchor.constraint(equalToConstant: 30),
            
            userInfoTextView.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -10),
            userInfoTextView.heightAnchor.constraint(equalToConstant: 70),
            
            editButton.widthAnchor.constraint(equalToConstant: 40),
            editButton.heightAnchor.constraint(equalToConstant: 40),
            
            editPhotoButton.widthAnchor.constraint(equalToConstant: 50),
            editPhotoButton.heightAnchor.constraint(equalToConstant: 50),
            editPhotoButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor),
            editPhotoButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            
            saveButton.widthAnchor.constraint(equalToConstant: 260),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            saveButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -30),
            saveButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            saveButton.topAnchor.constraint(greaterThanOrEqualTo: stackView.bottomAnchor, constant: 20)
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
        }
        picker.dismiss(animated: true)
    }
    
}

extension ProfileViewController: UITextFieldDelegate {
    
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    
}

extension ProfileViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter short info about you..."
            textView.textColor = UIColor.lightGray
            UserDefaults.standard.set(nil, forKey: "userInfoText")
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
}


