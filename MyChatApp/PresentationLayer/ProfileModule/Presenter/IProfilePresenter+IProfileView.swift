//
//  IProfilePresenter+IProfileView.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 26.04.2022.
//

import UIKit

protocol IProfilePresenter: AnyObject {
    
    var fileManager: DataService { get }
    var imageManager: ImageService { get }
    var themePicker: ThemeService { get }
    var user: User { get }
    
    init(
        view: IProfileView,
        fileManager: DataService,
        imageManager: ImageService,
        themePicker: ThemeService,
        router: IRouter
    )
    
    func onViewDidLoad()
    
    func networkPickerButtonTapped()
    
    func saveImage(imageName: String, image: UIImage)
    
    func deleteImage(imageName: String)

    func saveUser(completion: @escaping ((Bool) -> Void))
    
    func setNewPhoto(_ url: String)

}

protocol IProfileView: AnyObject {
    
    func configureUIWith(_ user: User)
    
    func setUserImage(_ image: UIImage?)
    
    func setNewPhoto(_ url: String)
    
    func disableSaveButton()
    
}