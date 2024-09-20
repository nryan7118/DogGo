//
//  AddScheduleViewTests.swift
//  DogGOTests
//
//  Created by Nick Ryan on 9/11/24.
//

import XCTest
import CoreData
@testable import DogGO

class ScheduleDataStoreTests: XCTestCase {
    var managedObjectContext: NSManagedObjectContext!
    var scheduleDataStore: ScheduleDataStore!
    var dogID: UUID!

    override func setUp() async throws{
        try await super.setUp()

        let persistentContainer = NSPersistentContainer(name: "DogGoCore")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]

        try await persistentContainer.loadPersistentStores { _, error in
            XCTAssertNil(error, "Failed to load in-memory store: \(String(describing: error))")
        }

        managedObjectContext = persistentContainer.viewContext
        scheduleDataStore = ScheduleDataStore(context: managedObjectContext)
        dogID = UUID()
    }


    override func tearDown() {
        managedObjectContext = nil
        scheduleDataStore = nil
        dogID = nil
        super.tearDown()
    }

    func testAddSchedule() async throws {
        // Ensure managedObjectContext is not nil
        guard let context = managedObjectContext else {
            XCTFail("managedObjectContext is nil.")
            return
        }

        let dog = Dog(context: context)
        dog.dogID = dogID

        let newSchedule = Schedule(context: context)
        newSchedule.scheduledEvent = "Test Walk"
        newSchedule.scheduledTime = Date()
        newSchedule.scheduledCategory = "Walk"
        newSchedule.scheduleID = UUID()
        newSchedule.dogRelationship = dog

        await scheduleDataStore.addSchedule(newSchedule, to: dog)
        // Await the fetch to ensure the data is loaded
        await scheduleDataStore.fetchSchedules(for: dog)

        XCTAssertEqual(scheduleDataStore.schedules.count, 1)
        XCTAssertEqual(scheduleDataStore.schedules.first?.scheduledEvent, "Test Walk")
    }

    func testFetchSchedulesForDog() async throws {
        guard let context = managedObjectContext else {
            XCTFail("managedObjectContext is nil.")
            return
        }

        let dog = Dog(context: context)
        dog.dogID = dogID

        let newSchedule = Schedule(context: managedObjectContext)
        newSchedule.scheduledEvent = "Test Walk"
        newSchedule.scheduledTime = Date()
        newSchedule.scheduledCategory = "Walk"
        newSchedule.scheduleID = UUID()
        newSchedule.dogRelationship = dog

        await scheduleDataStore.addSchedule(newSchedule, to: dog)

        // Await the fetch to ensure the data is loaded
        await scheduleDataStore.fetchSchedules(for: dog)

        XCTAssertEqual(scheduleDataStore.schedules.count, 1)
        XCTAssertEqual(scheduleDataStore.schedules.first?.scheduledEvent, "Test Walk")
    }

    func testDeleteSchedule() async throws {
        // Create and add a schedule
        let newSchedule = Schedule(context: managedObjectContext)
        newSchedule.scheduledEvent = "Test Event"
        newSchedule.scheduledTime = Date()
        newSchedule.scheduledCategory = "Work"
        newSchedule.scheduleID = UUID()

        // Ensure selectedDogID is set
        guard let dogID = dogID else {
            XCTFail("dogID is nil")
            return
        }
        let dog = Dog(context: managedObjectContext)
        dog.dogID = dogID

        newSchedule.dogRelationship = dog  // Make sure this is set

        await scheduleDataStore.addSchedule(newSchedule, to: dog)

        // Await the fetch to ensure the schedule was added
        await scheduleDataStore.fetchSchedules(for: dog)
        XCTAssertEqual(scheduleDataStore.schedules.count, 1)

        // Now delete the schedule
        await scheduleDataStore.deleteSchedule(newSchedule)

        // Await the fetch to ensure it was deleted
        await scheduleDataStore.fetchSchedules(for: dog)

        // Assert that the schedule is deleted
        XCTAssertEqual(scheduleDataStore.schedules.count, 0)
    }
}
