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
    @EnvironmentObject var vetInformationDataStore: VetInformationDataStore
    var dog: Dog

    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        Form {
            Section("Owner Information") {
                OwnerInformationSectionView(dog: dog)
            }

            Section("Vet Information") {

                if let selectedVet = dog.vetRelationship {
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
        
        .onAppear {
            if let vet = dog.vetRelationship {
                print("Vet relationshiop fouund: \(vet.vetFirstName ?? "Unknown")")
                      } else {
                    print("Vet information is nil for this dog")

                }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        }
    }

#Preview {
    let managedObjectContext = CoreDataStack.shared.context
    let sampleDog = Dog(context: managedObjectContext)
    let sampleVet = VetInformation(context: managedObjectContext)
    sampleVet.vetID = UUID() // Assign a valid ID
    sampleVet.vetFirstName = "Test Vet"

    sampleDog.vetRelationship = sampleVet
    
    return ContactView(dog: sampleDog)
        .environment(\.managedObjectContext, managedObjectContext)
        .environmentObject(VetInformationDataStore())
}
