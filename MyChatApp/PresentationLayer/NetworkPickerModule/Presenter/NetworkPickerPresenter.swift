//
//  NetworkPickerPresenter.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 27.04.2022.
//

import Foundation

final class NetworkPickerPresenter: INetworkPickerPresenter {
    
    weak var view: INetworkPickerView?
    
    var photoURLs: [PhotoItem] = []
    var photoFetcher: PhotoFetching
    var router: IRouter
    
    init(view: INetworkPickerView, photoFetcher: PhotoFetching, router: IRouter) {
        self.view = view
        self.photoFetcher = photoFetcher
        self.router = router
    }
    
    func onViewDidLoad() {
        getPhotoItems { [weak self] success in
            if success {
                self?.view?.getPhotoItemsSuccess()
            } else {
                self?.view?.getPhotoItemsFailure()
            }
        }
    }
    
    func photoHasChosen(_ url: String) {
        router.showMyProfileWithNewPhoto(url)
    }
    
    private func getPhotoItems(completion: @escaping (Bool) -> Void) {
        photoFetcher.getPhotoItems(query: "cat", quantity: 200) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self?.photoURLs = items ?? []
                    completion(true)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(false)
                }
            }
        }
    }
}
