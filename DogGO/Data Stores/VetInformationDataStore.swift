//
//  VetInformationDataStore.swift
//  DogGO
//
//  Created by Nick Ryan on 8/30/24.
//

import SwiftUI
import CoreData

class VetInformationDataStore: ObservableObject {
    @Published var vetInformationList: [VetInformation] = []
    public let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        Task {
            await fetchVetInformation()
        }
    }
    
    func fetchVetInformation() async {
        let fetchRequest: NSFetchRequest<VetInformation> = VetInformation.fetchRequest()
        do {
            let fetchedData = try await managedObjectContext.perform {
                try self.managedObjectContext.fetch(fetchRequest)
            }
            DispatchQueue.main.async {
                self.vetInformationList = fetchedData
            }
        } catch {
            print("Failed to fetch vet information: \(error.localizedDescription)")
        }
    }
    
    func addVetInformation(_ vetInformation: VetInformation) async {
        managedObjectContext.insert(vetInformation)
        await saveContext()
        await fetchVetInformation()
    }

    // New function to delete vet information
    func deleteVetInformation(_ vetInformation: VetInformation) async {
        managedObjectContext.delete(vetInformation)
        await saveContext()
        await fetchVetInformation() // Refresh the list after deletion
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
