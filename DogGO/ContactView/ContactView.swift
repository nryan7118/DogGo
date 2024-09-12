//
//  ContactView.swift
//  DogGO
//
//  Created by Nick Ryan on 9/7/24.
//

import SwiftUI
import CoreData

struct ContactView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    var dog: Dog
    
    @State private var selectedVet: VetInformation?
    
    var body: some View {
        VStack(alignment: .leading) {
            Form {
                Section("Owner Information") {
                    OwnerInformationSectionView(dog: dog)
                }
                
                Section("Vet Information") {
                    if let selectedVet = selectedVet {
                        ViewVetInformation(vet: selectedVet, dog: dog)
                    } else {
                        Text("Vet information not available")
                            .foregroundStyle(Color.gray)
                    }
                }
                
                Section("Emergency Contact") {
                    EmergencyContactSectionView(dog: dog)
                }
            }
            .padding([.leading, .trailing])
        }
        .onAppear(perform: fetchVet)  // Correct use of .onAppear here
    }
    
    private func fetchVet() {
        guard let vetID = dog.vetSelectedID else {
            print("No vet ID found for the dog.")
            return
        }
        
        let fetchRequest: NSFetchRequest<VetInformation> = VetInformation.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "vetID == %@", vetID as CVarArg)
        
        do {
            let vets = try managedObjectContext.fetch(fetchRequest)
            if let vet = vets.first {
                selectedVet = vet
            } else {
                print("No vet found for the given ID.")
            }
        } catch {
            print("Error fetching vet: \(error)")
        }
    }
}

#Preview {
    let managedObjectContext = CoreDataStack.shared.context
    let sampleDog = Dog(context: managedObjectContext)
    sampleDog.vetSelectedID = UUID()  // Assigning a UUID to simulate a saved dog

    return ContactView(dog: sampleDog)
        .environment(\.managedObjectContext, managedObjectContext)
}
