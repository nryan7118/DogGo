//
//  VetInformationView.swift
//  DogGO
//
//  Created by Nick Ryan on 8/24/24.
//

import SwiftUI
import CoreData

struct AddVetInformationView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @Binding var selectedVet: VetInformation?
    @State private var showAddVetForm = false
    @State private var vets: [VetInformation] = []
    @State private var searchText: String = ""
    
    @State private var vetFirstName: String = ""
    @State private var vetLastName: String = ""
    @State private var vetAddress1: String = ""
    @State private var vetAddress2: String = ""
    @State private var vetCity: String = ""
    @State private var vetState: String = ""
    @State private var vetZip: String = ""
    @State private var vetPhoneNumber: String = ""
    
    var dog = Dog(context: CoreDataStack.shared.context)
    
    var onNext: () -> Void
    let buttonCornerRadius: CGFloat = 10
    
    var body: some View {
            Form {
                VetInformationForm(
                    vetFirstName: $vetFirstName,
                    vetLastName: $vetLastName,
                    vetAddress1: $vetAddress1,
                    vetAddress2: $vetAddress2,
                    vetCity: $vetCity,
                    vetState: $vetState,
                    vetZip: $vetZip,
                    vetPhoneNumber: $vetPhoneNumber
                )
                .frame(maxWidth: .infinity)
                Button(action: {
                    saveVet()
                    onNext()
                }) {
                    Text("Save Vet Information")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(buttonCornerRadius)
                        .padding(.top)
                }
                .accessibilityLabel("Next")
            }
            .frame(maxWidth: .infinity)
            .padding()
        }

    private func saveVet() {
        
        let newVet = VetInformation(context: managedObjectContext)
        newVet.vetID = UUID()
        newVet.vetFirstName = vetFirstName
        newVet.vetLastName = vetLastName
        newVet.vetAddress1 = vetAddress1
        newVet.vetAddress2 = vetAddress2
        newVet.vetCity = vetCity
        newVet.vetState = vetState
        newVet.vetZip = vetZip
        newVet.vetPhoneNumber = vetPhoneNumber
        
        dog.vetSelectedID = newVet.vetID
    
        do {
            try managedObjectContext.save()
            vets.append(newVet)
            selectedVet = newVet
        } catch {
            print("Failed to save new vet: \(error)")
        }
    }
}

#Preview {
    let managedObjectContext = CoreDataStack.shared.context
    
    @State var selectedVet: VetInformation? = nil
    
    return AddVetInformationView(selectedVet: $selectedVet, onNext: {})
        .environment(\.managedObjectContext, managedObjectContext)
}



