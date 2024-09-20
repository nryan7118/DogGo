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
    private let managedObjectContext: NSManagedObjectContext
    @Published var alertMessage: String?

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.managedObjectContext = context
    }

    func fetchVetInformation(for vetID: UUID?) async {
        guard let validVetID = vetID else {
            await MainActor.run {
                self.alertMessage = "No vet ID found for the dog."
            }
            return
        }

        let fetchRequest: NSFetchRequest<VetInformation> = VetInformation.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "vetID == %@", validVetID as CVarArg)

        do {
            let fetchedData = try await managedObjectContext.perform {
                try self.managedObjectContext.fetch(fetchRequest)
            }

            await MainActor.run {
                self.vetInformationList = fetchedData
            }

        } catch {
            await MainActor.run {
                self.alertMessage = "Failed to fetch vet information: \(error.localizedDescription)"
            }
        }
    }

    func fetchAllVetInformation() async {
        let fetchRequest: NSFetchRequest<VetInformation> = VetInformation.fetchRequest()

        do {
            let fetchedData = try await managedObjectContext.perform {
                try self.managedObjectContext.fetch(fetchRequest)
            }
            await MainActor.run {
                self.vetInformationList = fetchedData
            }
        } catch {
            await MainActor.run {
                self.alertMessage = "Failed to fetch vet information: \(error.localizedDescription)"
            }
        }
    }

    func addVetInformation(_ vetInformation: VetInformation) async {
        managedObjectContext.insert(vetInformation)
        await saveContext()
        await fetchAllVetInformation()
    }

    func deleteVetInformation(_ vetInformation: VetInformation) async {
        managedObjectContext.delete(vetInformation)
        await saveContext()
        await fetchAllVetInformation() // Refresh the list after deletion
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
