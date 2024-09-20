//
//  VetInformationView.swift
//  DogGO
//
//  Created by Nick Ryan on 8/24/24.
//

import SwiftUI
import CoreData

struct AddVetInformationView: View {
    @EnvironmentObject var vetInformationDataStore: VetInformationDataStore

    @Binding var dog: Dog?
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
            }, label: {
                Text("Save Vet Information")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(buttonCornerRadius)
                    .padding(.top)
            })
            .accessibilityLabel("Next")
        }
        .frame(maxWidth: .infinity)
        .padding()
        .alert(isPresented: .constant(vetInformationDataStore.alertMessage != nil), content: {
            Alert(
                title: Text("Alert"),
                message: Text(vetInformationDataStore.alertMessage ?? ""),
                dismissButton: .default(Text("OK")) {
                    vetInformationDataStore.alertMessage = nil
                }
                )
        })
    }

    private func saveVet() {
        guard !vetFirstName.isEmpty, !vetLastName.isEmpty else {
            vetInformationDataStore.alertMessage = "Please provide first and last name for the vet."
            return
        }

        guard let dog = dog else {
            vetInformationDataStore.alertMessage = "No dog found to assign the vet too."
            return
        }
        
        let newVet = VetInformation(context: CoreDataStack.shared.context)
        newVet.vetID = UUID()
        newVet.vetFirstName = vetFirstName
        newVet.vetLastName = vetLastName
        newVet.vetAddress1 = vetAddress1
        newVet.vetAddress2 = vetAddress2
        newVet.vetCity = vetCity
        newVet.vetState = vetState
        newVet.vetZip = vetZip
        newVet.vetPhoneNumber = vetPhoneNumber

            dog.vetRelationship = newVet

        do {
            selectedVet = newVet
            CoreDataStack.shared.save()
            vetInformationDataStore.alertMessage = "Vet saved sucessfully"
            resetForm()
        } catch {
            vetInformationDataStore.alertMessage = "Failed to save vet: \(error.localizedDescription)"
        }
    }

    private func resetForm() {
        vetFirstName = ""
        vetLastName = ""
        vetAddress1 = ""
        vetAddress2 = ""
        vetCity = ""
        vetState = ""
        vetZip = ""
        vetPhoneNumber = ""
    }
}

#Preview {
    let managedObjectContext = CoreDataStack.shared.context

    @State var selectedVet: VetInformation?
    @State var dog: Dog? = Dog(context: managedObjectContext)

    return AddVetInformationView(dog: $dog, selectedVet: $selectedVet, onNext: {})
        .environment(\.managedObjectContext, managedObjectContext)
        .environmentObject(VetInformationDataStore())
}
