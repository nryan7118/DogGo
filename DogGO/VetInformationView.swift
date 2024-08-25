//
//  VetInformationView.swift
//  DogGO
//
//  Created by Nick Ryan on 8/24/24.
//

import SwiftUI

struct VetInformationView: View {
    @Binding var vetFirstName: String
    @Binding var vetLastName: String
    @Binding var vetAddress1: String
    @Binding var vetAddress2: String
    @Binding var vetCity: String
    @Binding var vetState: String
    @Binding var vetZipCode: String
    @Binding var vetPhoneNumber: String
    
    var body: some View {
        Form {
            Section("Vet Information") {
                VStack {
                    TextEntryRowView(title: "First Name", value: $vetFirstName)
                    TextEntryRowView(title: "Last Name", value: $vetLastName)
                }
            }
                    Section("Vets Address") {
                        
                    VStack {
                            TextEntryRowView(title: "Address", value: $vetAddress1)
                            TextEntryRowView(title: "Address Cont.", value: $vetAddress2)
                        HStack {
                            TextEntryRowView(title: "City", value: $vetCity)
                            TextEntryRowView(title: "State", value: $vetState)
                        }
                            TextEntryRowView(title: "Zip Code", value: $vetZipCode)
                        
                        }
                    }
                    TextEntryRowView(title: "Phone Number", value: $vetPhoneNumber)
            }
        }
    }


#Preview {
    VetInformationView(vetFirstName: .constant(""), vetLastName: .constant(""), vetAddress1: .constant(""), vetAddress2: .constant(""), vetCity: .constant(""), vetState: .constant(""), vetZipCode: .constant(""), vetPhoneNumber: .constant(""))
}
