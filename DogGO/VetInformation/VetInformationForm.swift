//
//  VetSelectionView.swift
//  DogGO
//
//  Created by Nick Ryan on 8/28/24.
//

import SwiftUI
import CoreData

struct VetInformationForm: View {
    @Binding var vetFirstName: String
    @Binding var vetLastName: String
    @Binding var vetAddress1: String
    @Binding var vetAddress2: String
    @Binding var vetCity: String
    @Binding var vetState: String
    @Binding var vetZip: String
    @Binding var vetPhoneNumber: String
    
    var body: some View {
        VStack {
            TextEntryRowView(title: "First Name", value: $vetFirstName)
            TextEntryRowView(title: "Last Name", value: $vetLastName)
            TextEntryRowView(title: "Vet Address", value: $vetAddress1)
            TextEntryRowView(title: "Address Cont.", value: $vetAddress2)
            TextEntryRowView(title: "City", value: $vetCity)
            TextEntryRowView(title: "State", value: $vetState)
            TextEntryRowView(title: "Zip Code", value: $vetZip)
            TextEntryRowView(title: "Phone Number", value: $vetPhoneNumber)
        }
    }
    
}
