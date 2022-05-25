//
//  PhotoFetcherTests.swift
//  MyChatAppTests
//
//  Created by Юрий Андрианов on 25.05.2022.
//

import XCTest
@testable import MyChatApp

class PhotoFetcherTests: XCTestCase {
    
    private var networkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        
        networkService = MockNetworkService()
    }
    
    func testRequestCalled() {
        // Arrange
        let photoFetcher = PhotoFetcher(networkService: networkService)
        
        // Act
        photoFetcher.getPhotoItems(query: "bar", quantity: 10) { _ in }
        
        // Assert
        XCTAssertTrue(networkService.invokedRequest)
    }
}
