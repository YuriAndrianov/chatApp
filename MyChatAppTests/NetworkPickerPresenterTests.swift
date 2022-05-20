//
//  NetworkPickerPresenterTests.swift
//  MyChatAppTests
//
//  Created by Юрий Андрианов on 16.05.2022.
//

import XCTest
@testable import MyChatApp

class NetworkPickerPresenterTests: XCTestCase {

    private var photoFetcher: MockPhotoFetcher!
    
    override func setUp() {
        super.setUp()
        
        photoFetcher = MockPhotoFetcher()
    }
    
    func testGetPhotoItemsCalled() {
        // Arrange
        let presenter = build()
        
        // Act
        presenter.onViewDidLoad()
        
        // Assert
        XCTAssertTrue(photoFetcher.invokedGetPhotoItems)
    }
  
    private func build() -> NetworkPickerPresenter {
        let moduleAssembly = MockModuleAssembly()
        let view = MockNetworkPickerView()
        let router = MockRouter(
            navigationController: CustomNavigationController(),
            assembly: moduleAssembly
        )
        
        return NetworkPickerPresenter(
            view: view,
            photoFetcher: photoFetcher,
            router: router
        )
    }
}
