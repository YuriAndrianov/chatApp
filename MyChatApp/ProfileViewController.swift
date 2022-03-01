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
    
    let fullnameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Firstname Lastname"
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let userInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Information about user"
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        button.backgroundColor = navBarBackgroundColor
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 19)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        
        print(editButton.frame) // в данном методе frame'ы вьюшек еще не заданы
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
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
    
    private func setupNavBar() {
        title = "My Profile"
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.backgroundColor = navBarBackgroundColor
        
        let closeButton = UIBarButtonItem(title: "Close",
                                          style: .plain,
                                          target: self,
                                          action: #selector(closeButtonTapped))
        
        self.navigationItem.rightBarButtonItem = closeButton
    }
    
    private func setupViews() {
        [profileImageView, fullnameLabel, userInfoLabel].forEach { stackView.addArrangedSubview($0) }
        [stackView, saveButton, editButton].forEach { view.addSubview($0) }
    }
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func editButtonTapped() {
        showAddPhotoAlertVC()
    }
    
    private func showAddPhotoAlertVC() {
        let alertVC = UIAlertController(title: "Выбрать фото...", message: nil, preferredStyle: .actionSheet)
        
        let cameraButton = UIAlertAction(title: "Камера", style: .default) { [weak self] _ in
            self?.showImagePicker(selectedSource: .camera)
        }
        
        let libraryButton = UIAlertAction(title: "Галерея", style: .default) { [weak self] _ in
            self?.showImagePicker(selectedSource: .photoLibrary)
        }
        
        let cancelButton = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
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
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 65),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -65),
            
            profileImageView.widthAnchor.constraint(equalToConstant: 240),
            profileImageView.heightAnchor.constraint(equalToConstant: 240),
            
            fullnameLabel.widthAnchor.constraint(equalToConstant: 240),
            
            userInfoLabel.widthAnchor.constraint(equalToConstant: 240),
            
            editButton.widthAnchor.constraint(equalToConstant: 40),
            editButton.heightAnchor.constraint(equalToConstant: 40),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -55),
            editButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 325),
            
            saveButton.widthAnchor.constraint(equalToConstant: 260),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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


