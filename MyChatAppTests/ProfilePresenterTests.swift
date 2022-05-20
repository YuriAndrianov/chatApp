//
//  ProfilePresenterTests.swift
//  MyChatAppTests
//
//  Created by Юрий Андрианов on 16.05.2022.
//

import XCTest
@testable import MyChatApp

class ProfilePresenterTests: XCTestCase {
    
    private var view: MockNetworkPickerView!
    private var fileManager: MockDataService!
    private var imageService: MockImageService!
    
    override func setUp() {
        super.setUp()
        
        view = MockNetworkPickerView()
        fileManager = MockDataService()
        imageService = MockImageService()
    }
    
    func testReadFromFileCalled() {
        // Arrange
        let presenter = build()
        fileManager?.stubbedReadFromFileCompletionResult = (nil, ())
        
        // Act
        presenter.onViewDidLoad()
        
        // Assert
        XCTAssertTrue(fileManager.invokedReadFromFile)
        XCTAssertFalse(imageService.invokedLoadImageFromDiskWith)
    }
    
    func testLoadImageFromDiskWith() {
        // Arrange
        let presenter = build()
        fileManager?.stubbedReadFromFileCompletionResult = (User(), ())
        
        // Act
        presenter.onViewDidLoad()
        
        // Assert
        XCTAssertEqual(imageService.invokedLoadImageFromDiskWithCount, 1)
    }
  
    private func build() -> ProfilePresenter {
        let moduleAssembly = MockModuleAssembly()
        let view = MockProfileView()
        let themePicker = MockThemeService()
        let router = MockRouter(
            navigationController: CustomNavigationController(),
            assembly: moduleAssembly
        )
        
        return ProfilePresenter(
            view: view,
            fileManager: fileManager,
            imageManager: imageService,
            themePicker: themePicker,
            router: router
        )
    }
}
