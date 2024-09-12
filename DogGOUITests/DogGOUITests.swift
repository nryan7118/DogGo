//
//  DogGOUITests.swift
//  DogGOUITests
//
//  Created by Nick Ryan on 8/23/24.
//

import XCTest

final class DogGOUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {}
    
    func testBasicInfoView() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Tap the Add button to open the form
        let addButton = app.navigationBars["Dogs"].buttons["Add"]
        XCTAssertTrue(addButton.exists, "Add button does not exist.")
        addButton.tap()
        
        // Wait for the Dog's Name text field to appear
        let dogNameTextField = app.textFields["dogNameTextField"]
        XCTAssertTrue(dogNameTextField.waitForExistence(timeout: 5), "Dog's Name text field does not exist.")
        dogNameTextField.tap()
        dogNameTextField.typeText("Buddy")
        
        // Select the breed
        let selectBreedButton = app.buttons["breedPicker"]
        XCTAssertTrue(selectBreedButton.exists, "Select a breed button does not exist.")
        selectBreedButton.tap()
        
        let breedSelection = app.scrollViews.otherElements.staticTexts["akita"]
        XCTAssertTrue(breedSelection.exists, "Breed 'akita' does not exist.")
        breedSelection.tap()
    }
    
    func testOwnerAndPhotoView() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Navigate to Owner and Photo View (assuming it's step 2)
        let addButton = app.navigationBars["Dogs"].buttons["Add"]
        XCTAssertTrue(addButton.exists, "Add button does not exist.")
        addButton.tap()
        
        // Go to the Owner and Photo View
        app.swipeUp()
        app.swipeUp()
        app.swipeUp()
        app.swipeUp()
        let nextButton = app.buttons["Next"]
        XCTAssertTrue(nextButton.exists, "Next button does not exist.")
        nextButton.tap()
        
        // Fill in the Owner information
        let ownerNameTextField = app.textFields["ownerNameTextField"]
        XCTAssertTrue(ownerNameTextField.exists, "Owner name text field does not exist.")
        ownerNameTextField.tap()
        ownerNameTextField.typeText("John Doe")
        
        let ownerPhoneTextField = app.textFields["ownerPhoneTextField"]
        XCTAssertTrue(ownerPhoneTextField.exists, "Owner phone text field does not exist.")
        ownerPhoneTextField.tap()
        ownerPhoneTextField.typeText("1234567890")
        
        // Fill in the Emergency Contact information
        let emergencyContactTextField = app.textFields["emergencyContactTextField"]
        XCTAssertTrue(emergencyContactTextField.exists, "Emergency contact text field does not exist.")
        emergencyContactTextField.tap()
        emergencyContactTextField.typeText("Jane Doe")
        
        let emergencyContactPhoneTextField = app.textFields["emergencyContactPhoneTextField"]
        XCTAssertTrue(emergencyContactPhoneTextField.exists, "Emergency contact phone text field does not exist.")
        emergencyContactPhoneTextField.tap()
        emergencyContactPhoneTextField.typeText("0987654321")
        
        // Tap Save to save the information
        let saveButton = app.buttons["saveButton"]
        XCTAssertTrue(saveButton.exists, "Save button does not exist.")
        saveButton.tap()
    }


}
                      
