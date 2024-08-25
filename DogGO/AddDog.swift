//
//  AddDog.swift
//  DogGO
//
//  Created by Nick Ryan on 8/23/24.
//

import SwiftUI
import SwiftData

struct AddDog: View {
    
    @State private var name: String = ""
    @State private var dob: Date = Date()
    @State private var breed: String = ""
    @State private var allergies: [String] = [""]
    @State private var likes: [String] = [""]
    @State private var dislikes: [String] = [""]
    @State private var scheduledEvent: [String] = [""]
    @State private var scheduledTime: [String] = [""]
    @State private var ownerName: [String] = [""]
    @State private var ownerPhone: [String] = [""]
    @State private var specialInstructions: String = ""
    @State private var emergencyContact: String = ""
    @State private var emergencyContactPhone: String = ""
    @State private var vetInformation: VetInformation = VetInformation(
        vetFirstName: "",
        vetLastName: "",
        vetAddress1: "",
        vetAddress2: "",
        vetCity: "",
        vetState: "",
        vetZip: "",
        vetPhoneNumber: "")
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
        
                    NavigationLink("Add Basic Info", destination: {
                        BasicInfoView(name: $name, breed: $breed, dob: $dob, likes: $likes, dislikes: $dislikes)
                    })
                
                
                    NavigationLink("Add Schedule", destination: {
                        AddScheduleView(scheduledEvent: $scheduledEvent, scheduledTime: $scheduledTime)
                    })
                
                
                    NavigationLink("Vet Information", destination: {
                        VetInformationView(
                            vetFirstName: $vetInformation.vetFirstName,
                            vetLastName: $vetInformation.vetLastName,
                            vetAddress1: $vetInformation.vetAddress1,
                            vetAddress2: $vetInformation.vetAddress2,
                            vetCity: $vetInformation.vetCity,
                            vetState: $vetInformation.vetState,
                            vetZipCode: $vetInformation.vetZip,
                            vetPhoneNumber: $vetInformation.vetPhoneNumber)
                    })
                
                Section {
                    Button("Save Dog") {
                        addDog()
                    }
                }
                .navigationTitle("Add Dog")
        }
    }
    
    private func addDog() {
        let newDog = Dog(name: name, dob: dob, breed: breed, allergies: allergies, likes: likes, dislikes: dislikes, scheduledEvent: scheduledEvent, scheduledTime: scheduledTime, ownerName: ownerName, ownerPhone: ownerPhone, emergencyContact: emergencyContact, emergencyContactPhone: emergencyContactPhone, specialInstructions: specialInstructions, vetInformation: vetInformation)
        
        modelContext.insert(newDog)
    }
}

#Preview {
    AddDog()
}
