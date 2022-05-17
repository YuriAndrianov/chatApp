//
//  ProfileTests.swift
//  MyChatAppUITests
//
//  Created by Юрий Андрианов on 17.05.2022.
//

import XCTest

final class ProfileTests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testProfile() {
        // Arrange
        
        let title = app.navigationBars["My Profile"].staticTexts["My Profile"]
        let editPhotoButton = app.scrollViews.buttons["camera.circle"]
        let editButton = app.scrollViews.buttons["Edit"]
        let fullnameTextField = app.scrollViews.textFields["Enter your name..."]
        let occupationTextField = app.scrollViews.textFields["Enter your occupation..."]
        let locationTextField = app.scrollViews.textFields["Enter your location..."]
        let saveButton = app.scrollViews.buttons["Save"]
        let cancelButton = app.scrollViews.buttons["Cancel"]
        let profileImage = app.scrollViews.otherElements.containing(.image, identifier:"person.circle").element
        let closeButton = app.navigationBars["My Profile"].buttons["Close"]
        let cancelSheetButton = app.sheets["Choose photo from..."].scrollViews.otherElements.buttons["Cancel"]
        let deletePhotoSheetButton = app.sheets["Choose photo from..."].scrollViews.otherElements.buttons["Delete photo"]
        let alertOKButton = app.alerts.scrollViews.otherElements.buttons["OK"]
        
        // Act
    
        app.navigationBars["Channels"].buttons["person.circle"].tap()
        
        // Assert
        
        if profileImage.waitForExistence(timeout: 2) {
            XCTAssertTrue(title.exists)
            XCTAssertTrue(profileImage.exists)
            XCTAssertTrue(editButton.exists)
            XCTAssertTrue(fullnameTextField.exists)
            XCTAssertTrue(occupationTextField.exists)
            XCTAssertTrue(locationTextField.exists)
            XCTAssertFalse(saveButton.exists)
            XCTAssertTrue(closeButton.exists)
            
            editButton.tap()
            
            XCTAssertFalse(editButton.exists)
            XCTAssertTrue(cancelButton.exists)
            XCTAssertTrue(editPhotoButton.exists)
            XCTAssertTrue(saveButton.exists)
            
            editPhotoButton.tap()
            cancelSheetButton.tap()
            cancelButton.tap()
            
            XCTAssertTrue(editButton.exists)
            XCTAssertFalse(cancelButton.exists)
            XCTAssertFalse(editPhotoButton.exists)
            XCTAssertTrue(profileImage.exists)

            closeButton.tap()
        } else {
            editButton.tap()
            editPhotoButton.tap()
            
            deletePhotoSheetButton.tap()
            
            _ = profileImage.waitForExistence(timeout: 2)
            
            saveButton.tap()
            alertOKButton.tap()
            
            XCTAssertFalse(editPhotoButton.exists)
            XCTAssertTrue(profileImage.exists)

            closeButton.tap()
        }
    }
    
}
