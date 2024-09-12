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
    var managedObjectContext: NSManagedObjectContext!
    var vetInformationDataStore: VetInformationDataStore!
    
    override func setUp() {
        super.setUp()
        
        let persistentContainer = NSPersistentContainer(name: "DogGo")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        
        let expectation = self.expectation(description: "Persistent container loaded")
        
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                XCTFail("Failed to load in-memory store: \(error)")
            } else {
                self.managedObjectContext = persistentContainer.viewContext
                self.vetInformationDataStore = VetInformationDataStore(managedObjectContext: self.managedObjectContext)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5)
    }
    
    override func tearDown() {
        managedObjectContext = nil
        vetInformationDataStore = nil
        super.tearDown()
    }
    
    func testAddVetInformation() async throws {
        let vetInfo = VetInformation(context: managedObjectContext)
        vetInfo.vetFirstName = "Test Vet"
        vetInfo.vetLastName = "Test Vet Last Name"
        vetInfo.vetPhoneNumber = "1234567890"
        vetInfo.vetAddress1 = "Test Address"
        vetInfo.vetAddress2 = "Address 2"
        vetInfo.vetCity = "Test City"
        vetInfo.vetState = "Test State"
        vetInfo.vetZip = "Test Zip"
        
        // Add vet information and await the save and fetch operations
        await vetInformationDataStore.addVetInformation(vetInfo)
        
        // Wait for the fetch operation to complete and check the result
        await Task.sleep(1_000_000_000)  // 1-second delay to ensure Core Data operations complete
        XCTAssertEqual(vetInformationDataStore.vetInformationList.count, 1)
        XCTAssertEqual(vetInformationDataStore.vetInformationList.first?.vetFirstName, "Test Vet")
    }
    
    func testDeleteVetInformation() async throws {
        // Create vet information entry
        let vetInfo = VetInformation(context: managedObjectContext)
        vetInfo.vetFirstName = "Test Vet"
        vetInfo.vetLastName = "Test Vet Last Name"
        vetInfo.vetPhoneNumber = "1234567890"
        vetInfo.vetAddress1 = "Test Address"
        vetInfo.vetAddress2 = "Address 2"
        vetInfo.vetCity = "Test City"
        vetInfo.vetState = "Test State"
        vetInfo.vetZip = "Test Zip"
        
        // Add vet information
        await vetInformationDataStore.addVetInformation(vetInfo)
        
        // Ensure the data is added properly
        await Task.sleep(1_000_000_000)  // 1-second delay to ensure Core Data operations complete
        XCTAssertEqual(vetInformationDataStore.vetInformationList.count, 1)
        
        // Delete vet information
        await vetInformationDataStore.deleteVetInformation(vetInfo)
        
        // Ensure the data is deleted
        await Task.sleep(1_000_000_000)  // 1-second delay to ensure Core Data operations complete
        XCTAssertEqual(vetInformationDataStore.vetInformationList.count, 0)
    }
}
