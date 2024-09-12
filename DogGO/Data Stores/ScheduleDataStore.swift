//
//  ScheduleDataStore.swift
//  DogGO
//
//  Created by Nick Ryan on 8/26/24.
//

import SwiftUI
import CoreData

class ScheduleDataStore: ObservableObject {
    @Published var schedules: [Schedule] = []
    public let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        Task {
            await fetchSchedules()
        }
    }

    func fetchSchedules() async {
        let fetchRequest: NSFetchRequest<Schedule> = Schedule.fetchRequest()

        do {
            let fetchedSchedules = try await managedObjectContext.perform {
                try self.managedObjectContext.fetch(fetchRequest)
            }
            DispatchQueue.main.async {
                self.schedules = fetchedSchedules
            }
        } catch {
            print("Failed to fetch schedules: \(error)")
        }
    }
    func fetchSchedules(for dogID: UUID) {
        let fetchRequest: NSFetchRequest<Schedule> = Schedule.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "selectedDogID == %@", dogID as CVarArg)

        do {
            self.schedules = try managedObjectContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch schedules: \(error)")
        }
    }

    func addSchedule(_ schedule: Schedule) async {
        managedObjectContext.insert(schedule)
        await saveContext()  // Await the save operation
        await fetchSchedules(for: schedule.selectedDogID ?? UUID())  // Fetch updated list
    }

    func deleteSchedule(_ schedule: Schedule) async {
        managedObjectContext.delete(schedule)
        await saveContext()  // Await the save operation
        schedules.removeAll { $0 == schedule }
        await fetchSchedules(for: schedule.selectedDogID ?? UUID())  // Fetch updated list
    }


    private func saveContext() async {
        do {
            try await managedObjectContext.perform {
                if self.managedObjectContext.hasChanges {
                    try self.managedObjectContext.save()
                }
            }
            print("Context saved successfully")
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
    }
