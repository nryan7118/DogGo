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

    func testCompleteFormEntry() throws {
        let app = XCUIApplication()
        app.launch()

        // Perform each step in sequence
        addDogBasicInfo(app: app)
        fillOwnerInfo(app: app)
        fillEmergencyContactInfo(app: app)
        fillVetInformation(app: app)

        saveForm(app: app)
    }

    func addDogBasicInfo(app: XCUIApplication) {
        // Tap 'Add' button
        let addButton = app.navigationBars["Dogs"].buttons["Add"]
        XCTAssertTrue(addButton.exists, "Add button does not exist.")
        addButton.tap()

        // Dog Name
        let dogNameTextField = app.textFields["dogNameTextField"]
        XCTAssertTrue(dogNameTextField.waitForExistence(timeout: 5), "Dog's Name text field does not exist.")
        dogNameTextField.tap()
        dogNameTextField.typeText("Buddy")

        // Dismiss the keyboard
        let returnKey = app.keyboards.buttons["Return"]
             if returnKey.exists {
                 returnKey.tap()
             }

        // Select Breed
        let selectBreedPicker = app.pickers["breedPicker"]
        XCTAssertTrue(selectBreedPicker.exists, "Select a breed button does not exist.")
        selectBreedPicker.tap()

        let breedPickerWheel = app.pickerWheels.element
        breedPickerWheel.adjust(toPickerWheelValue: "akita")

        XCTAssertEqual(breedPickerWheel.value as? String, "akita", "Breed picker did not select 'akita'")

        app.swipeUp()
        app.swipeUp()

        let nextButton = app.buttons["Next"]
        XCTAssertTrue(nextButton.exists, "Next button does not exist.")
        nextButton.tap()
    }

    func fillOwnerInfo(app: XCUIApplication) {
        // Fill Owner Information
        let ownerNameTextField = app.textFields["ownerNameTextField"]
        XCTAssertTrue(ownerNameTextField.exists, "Owner name text field does not exist.")
        ownerNameTextField.tap()
        ownerNameTextField.typeText("John Doe")

        // Dismiss the keyboard
        app.tap()

        let ownerPhoneTextField = app.textFields["ownerPhoneTextField"]
        XCTAssertTrue(ownerPhoneTextField.exists, "Owner phone text field does not exist.")
        ownerPhoneTextField.tap()
        ownerPhoneTextField.typeText("1234567890")
    }

    func fillEmergencyContactInfo(app: XCUIApplication) {
        // Emergency Contact Info
        let emergencyContactTextField = app.textFields["emergencyContactTextField"]
        XCTAssertTrue(emergencyContactTextField.exists, "Emergency contact text field does not exist.")
        emergencyContactTextField.tap()
        emergencyContactTextField.typeText("Jane Doe")
        let returnKey = app.keyboards.buttons["Return"]
             if returnKey.exists {
                 returnKey.tap()
             }

        let emergencyContactPhoneTextField = app.textFields["emergencyContactPhoneTextField"]
        XCTAssertTrue(emergencyContactPhoneTextField.exists, "Emergency contact phone text field does not exist.")
        emergencyContactPhoneTextField.tap()
        emergencyContactPhoneTextField.typeText("0987654321")

        // Dismiss the keyboard
             if returnKey.exists {
                 returnKey.tap()
             }
        app.swipeUp()

        let saveButton = app.buttons["saveButton"]
        XCTAssertTrue(saveButton.exists, "Save button does not exist.")
        saveButton.tap()
    }

    func fillVetInformation(app: XCUIApplication) {
            let vetFirstNameTextField = app.textFields["vetFirstName"]
            XCTAssertTrue(vetFirstNameTextField.exists, "Vet first name text field does not exist.")
            vetFirstNameTextField.tap()
            vetFirstNameTextField.typeText("Joe")

            let returnKey = app.keyboards.buttons["Return"]
                if returnKey.exists {
                returnKey.tap()
            }

            let vetLastNameTextField = app.textFields["vetLastName"]
            XCTAssertTrue(vetLastNameTextField.exists, "Vet last name ext field does not exist.")
            vetLastNameTextField.tap()
            vetLastNameTextField.typeText("Exotic")

            if returnKey.exists {
                returnKey.tap()
            }

            let vetAddress1TextField = app.textFields["vetAddress1"]
            XCTAssertTrue(vetAddress1TextField.exists, "Vet address 1 does not exist.")
            vetAddress1TextField.tap()
            vetAddress1TextField.typeText("12 Tiger Way.")

            if returnKey.exists {
                returnKey.tap()
            }

            let vetAddress2TextField = app.textFields["vetAddress2"]
            XCTAssertTrue(vetAddress2TextField.exists, "Vet address 2 does not exist.")
            vetAddress2TextField.tap()
            vetAddress2TextField.typeText("Bone Town")

            if returnKey.exists {
                returnKey.tap()
            }

            let vetCityTextField = app.textFields["vetCity"]
            XCTAssertTrue(vetCityTextField.exists, "Vet city does not exist")
            vetCityTextField.tap()
            vetCityTextField.typeText("Play Time")

            if returnKey.exists {
                returnKey.tap()
            }

            let vetStateTextField = app.textFields["vetState"]
            XCTAssertTrue(vetStateTextField.exists, "Vet state does not exists")
            vetStateTextField.tap()
            vetStateTextField.typeText("Ball")

            if returnKey.exists {
                returnKey.tap()
            }

            let vetZipTextField = app.textFields["vetZip"]
            XCTAssertTrue(vetZipTextField.exists, "Vet zip does not exists.")
            vetZipTextField.tap()
            vetZipTextField.typeText("34322")

            if returnKey.exists {
                returnKey.tap()
            }

            let vetPhoneTextField = app.textFields["vetPhone"]
            XCTAssertTrue(vetStateTextField.exists, "Vet Phone does not exists.")
            vetPhoneTextField.tap()
            vetPhoneTextField.typeText("349-232-1233")

            if returnKey.exists {
                returnKey.tap()
            }
        }

    func saveForm(app: XCUIApplication) {
        // Save Button
        app.tap()
        app.swipeUp()
        
        let nextButton = app.buttons["Next"]
        XCTAssertTrue(nextButton.exists, "Next button does not exist.")
        nextButton.tap()
    }
}
