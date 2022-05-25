//
//  ProfilePresenter.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 26.04.2022.
//

import UIKit

final class ProfilePresenter: IProfilePresenter {
    
    weak var view: IProfileView?
    
    var fileManager: IDataService
    var imageManager: IImageService
    var themePicker: IThemeService
    var user: User = User()
    var router: IRouter
    
    init(
        view: IProfileView,
        fileManager: IDataService,
        imageManager: IImageService,
        themePicker: IThemeService,
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
            guard let user = user else { return }
            
            self?.user = user
            self?.view?.configureUI(with: user)
            
            self?.imageManager.loadImageFromDiskWith(fileName: "User") { image in
                DispatchQueue.main.async {
                    self?.view?.setUserImage(image)
                    self?.view?.disableSaveButton()
                }
            }
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
    
    func userInfoDidEnter(fullname: String?, occupation: String?, location: String?) {
        user.fullname = fullname
        user.occupation = occupation
        user.location = location
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
