//
//  DogDataStore.swift
//  DogGO
//
//  Created by Nick Ryan on 8/26/24.
//

import SwiftUI
import CoreData

class DogDataStore: ObservableObject {
    @Published var dogs: [Dog] = []
    @Published var alertMessage: String?

    private let managedObjectContext: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.managedObjectContext = context
        Task {
            await fetchDogs()
        }
    }

    // Fetch existing dogs from Core Data
    func fetchDogs() async {
        let fetchRequest: NSFetchRequest<Dog> = Dog.fetchRequest()

        do {
            let fetchedDogs = try await managedObjectContext.perform {
                try self.managedObjectContext.fetch(fetchRequest)
            }
            await MainActor.run {
                self.dogs = fetchedDogs
            }
        } catch {
            await MainActor.run {
                self.alertMessage = "Failed to fetch dogs: \(error.localizedDescription)"
            }
        }
    }

    // Add new dog (only when user explicitly adds one)
    func addDog(_ dog: Dog) {
        saveContext()
        Task {
            await fetchDogs()
        }
    }

    // Delete a dog
    func deleteDog(_ dog: Dog) {
        managedObjectContext.delete(dog)
        saveContext()
        Task {
            await fetchDogs()
        }
    }

    private func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            alertMessage = "Failed to save dog: \(error.localizedDescription)"
        }
    }
}
