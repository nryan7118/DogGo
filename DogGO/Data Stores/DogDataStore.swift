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
    public let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
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
            
            DispatchQueue.main.async {
                self.dogs = fetchedDogs
            }
        } catch {
            print("Failed to fetch dogs: \(error)")
        }
    }

    
    // Add new dog (only when user explicitly adds one)
    func addDog(_ dog: Dog) {
        dogs.append(dog)
        saveContext()
    }
    
    // Delete a dog
    func deleteDog(_ dog: Dog) {
        managedObjectContext.delete(dog)
        saveContext()
    }
    private func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
