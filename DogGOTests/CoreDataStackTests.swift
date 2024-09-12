//
//  CoreDataStackTests.swift
//  DogGOTests
//
//  Created by Nick Ryan on 9/11/24.
//

import XCTest
import CoreData
@testable import DogGO

final class CoreDataStackTests: XCTestCase {
    
    var coreDataStack: CoreDataStack!
    
    override func setUpWithError() throws {
        // Set up an in-memory CoreData stack for testing
        coreDataStack = CoreDataStack(inMemory: true)
    }
    
    override func tearDownWithError() throws {
        // Clean up after each test
        coreDataStack = nil
    }
    
    // Test if context is correctly initialized
    func testCoreDataStackInitialization() throws {
        let context = coreDataStack.context
        XCTAssertNotNil(context, "Managed object context should not be nil.")
    }
    
    // Test saving data in the in-memory store
    func testSavingInMemoryStore() throws {
        let context = coreDataStack.context
        let dog = Dog(context: context)
        dog.name = "Test Dog"
        
        coreDataStack.save()
        
        let fetchRequest: NSFetchRequest<Dog> = Dog.fetchRequest()
        let dogs = try context.fetch(fetchRequest)
        
        XCTAssertEqual(dogs.count, 1, "There should be exactly one dog saved in the in-memory store.")
        XCTAssertEqual(dogs.first?.name, "Test Dog", "The dog's name should be 'Test Dog'.")
    }
    
    // Test that no data persists after resetting the stack
    func testInMemoryStoreResets() throws {
        // Step 1: Use the initial context and add a dog
        var context = coreDataStack.context
        let dog = Dog(context: context)
        dog.name = "Persistent Dog"
        
        coreDataStack.save()

        // Step 2: Fetch and ensure the dog is saved in the current store
        var fetchRequest: NSFetchRequest<Dog> = Dog.fetchRequest()
        var dogs = try context.fetch(fetchRequest)
        XCTAssertEqual(dogs.count, 1, "There should be exactly one dog saved in the in-memory store.")

        // Step 3: Re-initialize the CoreDataStack (this should reset the in-memory store)
        coreDataStack = CoreDataStack(inMemory: true)
        context = coreDataStack.context // Important: Fetch a fresh context from the new in-memory store
        
        // Step 4: Perform a fetch from the new context (should be empty)
        dogs = try context.fetch(fetchRequest)
        XCTAssertEqual(dogs.count, 0, "There should be no dogs in the store after re-initializing the in-memory store.")
    }
}

