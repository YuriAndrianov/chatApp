//
//  IProfilePresenter+IProfileView.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 26.04.2022.
//

import UIKit

protocol IProfilePresenter: AnyObject {
    
    var fileManager: IDataService { get }
    var imageManager: IImageService { get }
    var themePicker: IThemeService { get }
    var user: User { get }
    
    init(
        view: IProfileView,
        fileManager: IDataService,
        imageManager: IImageService,
        themePicker: IThemeService,
        router: IRouter
    )
    
    func onViewDidLoad()
    
    func networkPickerButtonTapped()
    
    func saveImage(imageName: String, image: UIImage)
    
    func deleteImage(imageName: String)
    
    func saveUser(completion: @escaping ((Bool) -> Void))
    
    func setNewPhoto(_ url: String)
    
    func userInfoDidEnter(fullname: String?, occupation: String?, location: String?)
    
}

protocol IProfileView: AnyObject {
    
    func configureUI(with user: User)
    
    func setUserImage(_ image: UIImage?)
    
    func setNewPhoto(_ url: String)
    
    func disableSaveButton()
    
}
