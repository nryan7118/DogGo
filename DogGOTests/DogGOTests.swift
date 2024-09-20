//
//  DogGOTests.swift
//  DogGOTests
//
//  Created by Nick Ryan on 8/23/24.
//

import XCTest
import CoreData
@testable import DogGO

final class DogGOTests: XCTestCase {

    var coreDataStack: CoreDataStack!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()

        coreDataStack = CoreDataStack(inMemory: true)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        coreDataStack = nil
        try super.tearDownWithError()
    }

    func testExample() throws {

        let context = coreDataStack.context
        let dog = Dog(context: context)
        dog.name = "Buddy"
        dog.breed = "Golder Retriever"
        dog.dogID = UUID()
        coreDataStack.save()
        let fetchRequest: NSFetchRequest<Dog> = Dog.fetchRequest()
        let dogs = try context.fetch(fetchRequest)
        XCTAssertEqual(dogs.count, 1)
        XCTAssertEqual(dogs.first?.name, "Buddy")
    }

    func testPerformanceExample() throws {
        measure {

        }
    }

}
