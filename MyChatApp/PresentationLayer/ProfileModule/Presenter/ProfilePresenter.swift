//
//  ProfilePresenter.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 26.04.2022.
//

import UIKit

final class ProfilePresenter: IProfilePresenter {
    
    weak var view: IProfileView?
    
    var fileManager: DataService
    var imageManager: ImageService
    var themePicker: ThemeService
    var user: User = User()
    var router: IRouter
    
    init(
        view: IProfileView,
        fileManager: DataService,
        imageManager: ImageService,
        themePicker: ThemeService,
        router: IRouter
    ) {
        self.view = view
        self.fileManager = fileManager
        self.imageManager = imageManager
        self.themePicker = themePicker
        self.router = router
    }
    
    func onViewDidLoad() {
        fileManager.readFromFile { [weak self] user in
            guard let self = self else { return }
            if let user = user {
                self.user = user
                self.view?.configureUIWith(user)
            }
        }
        
        imageManager.loadImageFromDiskWith(fileName: "User") { [weak self] image in
            guard let self = self else { return }
            self.view?.setUserImage(image)
        }
    }
    
    func networkPickerButtonTapped() {
        router.showNetworkPicker()
    }
    
    func saveImage(imageName: String, image: UIImage) {
        imageManager.saveImage(imageName: "User", image: image)
    }
    
    func deleteImage(imageName: String) {
        imageManager.deleteImage(imageName: "User")
    }
    
    func saveUser(completion: @escaping ((Bool) -> Void)) {
        fileManager.writeToFile(user, completion: completion)
    }
    
    func setNewPhoto(_ url: String) {
        guard let url = URL(string: url) else { return }
        
        let networkService = NetworkService()
        
        networkService.request(from: url) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let newImage = UIImage(data: data)
                    self?.view?.setUserImage(newImage)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
}
