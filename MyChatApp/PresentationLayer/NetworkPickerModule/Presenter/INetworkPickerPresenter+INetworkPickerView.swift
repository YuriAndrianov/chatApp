//
//  INetworkPickerPresenter+INetworkPickerView.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 27.04.2022.
//

import Foundation

protocol INetworkPickerPresenter: AnyObject {
    
    var photoURLs: [PhotoItem] { get set }
    var photoFetcher: PhotoFetching { get }
    
    init(
        view: INetworkPickerView,
        photoFetcher: PhotoFetching,
        router: IRouter
    )
    
    func onViewDidLoad()
    func photoHasChosen(_ url: String)
    
}

protocol INetworkPickerView: AnyObject {
    
    func success()
    func failure()
    
}
