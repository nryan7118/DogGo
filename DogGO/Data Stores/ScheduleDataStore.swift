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
    @Published var alertMessage: String?

    private let managedObjectContext: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.managedObjectContext = context
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
            await MainActor.run {
                self.schedules = fetchedSchedules
            }
        } catch {
            await MainActor.run {
                self.alertMessage = "Failed to fetch schedules: \(error)"
            }
        }
    }

    func fetchSchedules(for dog: Dog) async {
        let fetchRequest: NSFetchRequest<Schedule> = Schedule.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dogRelationship == %@", dog)

        do {
            let fetchedSchedules = try await managedObjectContext.perform {
                try self.managedObjectContext.fetch(fetchRequest)
            }
            await MainActor.run {
                self.schedules = fetchedSchedules
            }
        } catch {
            await MainActor.run {
                self.alertMessage = "Failed to fetch schedules: \(error)"
            }
        }
    }

    func addSchedule(_ schedule: Schedule, to dog: Dog) async {
        managedObjectContext.insert(schedule)
        schedule.dogRelationship = dog

        await saveContext()  // Await the save operation

        await fetchSchedules(for: dog)  // Fetch updated list
    }

    func deleteSchedule(_ schedule: Schedule) async {
        let dog = schedule.dogRelationship
        managedObjectContext.delete(schedule)
        await saveContext()
        schedules.removeAll { $0 == schedule }

        if let dog = dog {
            await fetchSchedules(for: dog)
        }

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
            await MainActor.run {
                self.alertMessage = "Failed to save context: \(error.localizedDescription)"
            }
        }
    }
}
