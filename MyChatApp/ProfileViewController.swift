//
//  ViewController.swift
//  MyChatApp
//
//  Created by MacBook on 23.02.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .systemGray
        imageView.layer.cornerRadius = 120
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let fullNameTextField: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.text = "Firstname Lastname"
        field.font = .boldSystemFont(ofSize: 24)
        field.isEnabled = false
        field.layer.cornerRadius = 6
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let userInfoTextField: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.text = "Information about user"
        field.font = .systemFont(ofSize: 16)
        field.isEnabled = false
        field.layer.cornerRadius = 6
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let editButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let editPhotoButton: UIButton = {
        let button = UIButton()
        button.tintColor = .link
        button.setBackgroundImage(UIImage(systemName: "camera.circle.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        button.addTarget(self, action: #selector(editPhotoButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 32
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "saveButtonColor")
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 19)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        
        return scroll
    }()
    
    var isEditingAllowed = false {
        didSet {
            if isEditingAllowed == true {
                editButton.setTitle("Done", for: .normal)
                fullNameTextField.isEnabled = true
                fullNameTextField.becomeFirstResponder()
                userInfoTextField.isEnabled = true
                UIView.animate(withDuration: 0.2) {
                    self.editPhotoButton.alpha = 1
                    self.fullNameTextField.backgroundColor = .secondarySystemBackground
                    self.userInfoTextField.backgroundColor = .secondarySystemBackground
                }
            } else {
                editButton.setTitle("Edit", for: .normal)
                fullNameTextField.isEnabled = false
                userInfoTextField.isEnabled = false
                UIView.animate(withDuration: 0.2) {
                    self.editPhotoButton.alpha = 0
                    self.fullNameTextField.backgroundColor = .systemBackground
                    self.userInfoTextField.backgroundColor = .systemBackground
                }
            }
        }
    }
    
    convenience init() {
        // print(editButton.frame) // обращаемся к проперти editButton, относящемуся к self, который еще не инициализирован, поэтому здесь распечатать фрейм нельзя
        self.init(nibName: nil, bundle: nil)
        print(editButton.frame)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(#function)
        
        setupNavBar()
        setupViews()
        setConstraints()
        setDelegates()
        
        print(editButton.frame) // в данном методе frame'ы вьюшек еще не заданы
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        
        registerObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
        
        print(editButton.frame) // на данном этапе frame'ы уже известны
    }
    
    override func viewWillLayoutSubviews() {
        print(#function)
        print(editButton.frame)
    }
    
    override func viewDidLayoutSubviews() {
        print(#function)
        scrollView.frame = view.bounds
        print(editButton.frame)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(#function)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func registerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setDelegates() {
        fullNameTextField.delegate = self
        userInfoTextField.delegate = self
    }
    
    private func setupNavBar() {
        title = "My Profile"
        view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.backgroundColor = UIColor(named: "navBarBackgroundColor")
        
        let closeButton = UIBarButtonItem(title: "Close",
                                          style: .plain,
                                          target: self,
                                          action: #selector(closeButtonTapped))
        
        self.navigationItem.rightBarButtonItem = closeButton
    }
    
    private func setupViews() {
        [profileImageView, fullNameTextField, userInfoTextField, editButton].forEach { stackView.addArrangedSubview($0) }
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
        isEditingAllowed = !isEditingAllowed
    }
    
    @objc private func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc private func keyboardWillHide(_ notification:Notification) {
        scrollView.contentInset = .zero
    }
    
    private func showAddPhotoAlertVC() {
        let alertVC = UIAlertController(title: "Choose photo from...", message: nil, preferredStyle: .actionSheet)
        
        let cameraButton = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            self?.showImagePicker(selectedSource: .camera)
        }
        
        let libraryButton = UIAlertAction(title: "Gallery", style: .default) { [weak self] _ in
            self?.showImagePicker(selectedSource: .photoLibrary)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertVC.addAction(cameraButton)
        alertVC.addAction(libraryButton)
        alertVC.addAction(cancelButton)
        
        present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - Constraints
extension ProfileViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            profileImageView.widthAnchor.constraint(equalToConstant: 240),
            profileImageView.heightAnchor.constraint(equalToConstant: 240),
            
            fullNameTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -10),
            userInfoTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -10),
            
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


