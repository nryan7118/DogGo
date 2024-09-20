//
//  VetInformationDataStoreTests.swift
//  DogGOTests
//
//  Created by Nick Ryan on 9/11/24.
//

import XCTest
import CoreData
@testable import DogGO

final class VetInformationDataStoreTests: XCTestCase {
    var vetInformationDataStore: VetInformationDataStore!
    var coreDataStack: CoreDataStack!

    override func setUp() async throws {
        try await super.setUp()

       coreDataStack = CoreDataStack(inMemory: true)
        vetInformationDataStore = VetInformationDataStore(context: coreDataStack.context)
        }

    override func tearDown() {
        vetInformationDataStore = nil
        coreDataStack = nil
        super.tearDown()
    }

    func testAddVetInformation() async throws {
        let context = coreDataStack.context
        let vetInfo = VetInformation(context: context)
        vetInfo.vetFirstName = "Test Vet"
        vetInfo.vetLastName = "Test Vet Last Name"
        vetInfo.vetPhoneNumber = "1234567890"
        vetInfo.vetAddress1 = "Test Address"
        vetInfo.vetAddress2 = "Address 2"
        vetInfo.vetCity = "Test City"
        vetInfo.vetState = "Test State"
        vetInfo.vetZip = "Test Zip"

        // Add vet information and await the save and fetch operations
        await vetInformationDataStore!.addVetInformation(vetInfo)

        // Wait for the fetch operation to complete and check the result
        try await Task.sleep(nanoseconds: 1_000_000_000)  // 1-second delay to ensure Core Data operations complete
        XCTAssertEqual(vetInformationDataStore!.vetInformationList.count, 1)
        XCTAssertEqual(vetInformationDataStore!.vetInformationList.first?.vetFirstName, "Test Vet")
    }

    func testDeleteVetInformation() async throws {
        // Create vet information entry
        let context = coreDataStack.context
        let vetInfo = VetInformation(context: context)
        vetInfo.vetFirstName = "Test Vet"
        vetInfo.vetLastName = "Test Vet Last Name"
        vetInfo.vetPhoneNumber = "1234567890"
        vetInfo.vetAddress1 = "Test Address"
        vetInfo.vetAddress2 = "Address 2"
        vetInfo.vetCity = "Test City"
        vetInfo.vetState = "Test State"
        vetInfo.vetZip = "Test Zip"

        // Add vet information
        await vetInformationDataStore!.addVetInformation(vetInfo)

        // Ensure the data is added properly
        try await Task.sleep(nanoseconds: 1_000_000_000)  // 1-second delay to ensure Core Data operations complete
        XCTAssertEqual(vetInformationDataStore!.vetInformationList.count, 1)

        // Delete vet information
        await vetInformationDataStore!.deleteVetInformation(vetInfo)

        // Ensure the data is deleted
        try await Task.sleep(nanoseconds: 1_000_000_000)  // 1-second delay to ensure Core Data operations complete
        XCTAssertEqual(vetInformationDataStore!.vetInformationList.count, 0)
    }
}
