//
//  DogDataStoreTests.swift
//  DogGOTests
//
//  Created by Nick Ryan on 8/26/24.
//

import XCTest
import CoreData
@testable import DogGO

class DogDataStoreTests: XCTestCase {
    var managedObjectContext: NSManagedObjectContext!
    var dataStore: DogDataStore!

    override func setUp() async throws {
        try await super.setUp()

        // Set up the in-memory Core Data stack for testing
        let persistentContainer = NSPersistentContainer(name: "DogGoCore")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]

         persistentContainer.loadPersistentStores { _, error in
            XCTAssertNil(error, "Failed to load in-memory store: \(error!)")
        }
        managedObjectContext = persistentContainer.viewContext
        dataStore = DogDataStore(context: managedObjectContext)
    }

    @MainActor
    func testAddDog() async throws {
        dataStore = DogDataStore(context: managedObjectContext)

        await dataStore.fetchDogs()
        let initialCount = dataStore.dogs.count

        let newDog = Dog(context: managedObjectContext)
        newDog.dogID = UUID()
        newDog.name = "Test Dog"
        newDog.dob = Date()
        newDog.breed = "Test Breed"
        newDog.likes = [] as NSObject
        newDog.dislikes = [] as NSObject
        newDog.ownerName = "Text Owner Name"
        newDog.ownerPhone = "Test Owner Phone"
        newDog.emergencyContact = "Test Contact"
        newDog.emergencyContactPhone = "Test Contact Phone"
        newDog.specialInstructions = "Test"

        await dataStore.addDog(newDog)
        await dataStore.fetchDogs()

        XCTAssertEqual(dataStore.dogs.count, initialCount + 1)
        XCTAssertTrue(dataStore.dogs.contains(where: { $0.name == "Test Dog" }))
    }

    @MainActor
    func testDeleteDog() throws {
        let newDog = Dog(context: managedObjectContext)
        newDog.dogID = UUID()
        newDog.name = "Test Dog"
        newDog.dob = Date()
        newDog.breed = "Test Breed"
        newDog.likes = [] as NSObject
        newDog.dislikes = [] as NSObject
        newDog.ownerName = "Owner Name"
        newDog.ownerPhone = "Owner Phone"
        newDog.emergencyContact = "Test Contact"
        newDog.emergencyContactPhone = "Test Contact Phone"
        newDog.specialInstructions = "Test"

        dataStore.addDog(newDog)

        dataStore.deleteDog(newDog)

        XCTAssertFalse(dataStore.dogs.contains(where: { $0.name == "Test Dog" }))
    }
}
