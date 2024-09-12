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
        let persistentContainer = NSPersistentContainer(name: "DogGo")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]

        await persistentContainer.loadPersistentStores { storeDescription, error in
            XCTAssertNil(error, "Failed to load in-memory store: \(error!)")
        }

        managedObjectContext = persistentContainer.viewContext
        dataStore = DogDataStore(managedObjectContext: managedObjectContext)
    }

    @MainActor
    func testAddDog() throws {
        let initialCount = dataStore.dogs.count
        
        let newDog = Dog(context: managedObjectContext)
        newDog.dogID = UUID()
        newDog.name = "Test Dog"
        newDog.dob = Date()
        newDog.breed = "Test Breed"
        newDog.allergies = [] as NSObject
        newDog.likes = [] as NSObject
        newDog.dislikes = [] as NSObject
        newDog.ownerName = [] as NSObject
        newDog.ownerPhone = [] as NSObject
        newDog.emergencyContacts = "Test Contact"
        newDog.emergencyContactPhone = "Test Contact Phone"
        newDog.specialInstructions = "Test"
        
        dataStore.addDog(newDog)

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
        newDog.allergies = [] as NSObject
        newDog.likes = [] as NSObject
        newDog.dislikes = [] as NSObject
        newDog.ownerName = [] as NSObject
        newDog.ownerPhone = [] as NSObject
        newDog.emergencyContacts = "Test Contact"
        newDog.emergencyContactPhone = "Test Contact Phone"
        newDog.specialInstructions = "Test"
        
        dataStore.addDog(newDog)

        dataStore.deleteDog(newDog)

        XCTAssertFalse(dataStore.dogs.contains(where: { $0.name == "Test Dog" }))
    }
}
