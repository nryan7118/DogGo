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
                self.scheduleDataStore = ScheduleDataStore(managedObjectContext: self.managedObjectContext)
                self.dogID = UUID()
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5)
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
        
        let newSchedule = Schedule(context: context)
        newSchedule.scheduledEvent = "Test Walk"
        newSchedule.scheduledTime = Date()
        newSchedule.scheduledCategory = "Walk"
        newSchedule.scheduleID = UUID()
        newSchedule.selectedDogID = dogID
        
        await scheduleDataStore.addSchedule(newSchedule)
        
        // Await the fetch to ensure the data is loaded
        await scheduleDataStore.fetchSchedules(for: dogID)
        
        XCTAssertEqual(scheduleDataStore.schedules.count, 1)
        XCTAssertEqual(scheduleDataStore.schedules.first?.scheduledEvent, "Test Walk")
    }
    
    func testFetchSchedulesForDog() async throws {
        guard let scheduleDataStore = scheduleDataStore, let dogID = dogID else {
            XCTFail("scheduleDataStore or dogID is nil")
            return
        }
        
        let newSchedule = Schedule(context: managedObjectContext)
        newSchedule.scheduledEvent = "Test Walk"
        newSchedule.scheduledTime = Date()
        newSchedule.scheduledCategory = "Walk"
        newSchedule.scheduleID = UUID()
        newSchedule.selectedDogID = dogID
        
        await scheduleDataStore.addSchedule(newSchedule)
        
        // Await the fetch to ensure the data is loaded
        await scheduleDataStore.fetchSchedules(for: dogID)
        
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
        
        newSchedule.selectedDogID = dogID  // Make sure this is set
        
        await scheduleDataStore.addSchedule(newSchedule)
        
        // Await the fetch to ensure the schedule was added
        await scheduleDataStore.fetchSchedules(for: dogID)
        XCTAssertEqual(scheduleDataStore.schedules.count, 1)
        
        // Now delete the schedule
        await scheduleDataStore.deleteSchedule(newSchedule)
        
        // Await the fetch to ensure it was deleted
        await scheduleDataStore.fetchSchedules(for: dogID)
        
        // Assert that the schedule is deleted
        XCTAssertEqual(scheduleDataStore.schedules.count, 0)
    }
}
