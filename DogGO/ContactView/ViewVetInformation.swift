//
//  ViewVetInformation.swift
//  
//
//  Created by Nick Ryan on 9/6/24.
//

import SwiftUI

struct ViewVetInformation: View {
    var vet: VetInformation
    var dog: Dog

    let imageLength: CGFloat = 100.0

    var body: some View {
        HStack {
            Image("pawStethescope")
                .resizable()
                .frame(width: imageLength, height: imageLength)
                .padding(.trailing, 10)
            Spacer()
            VStack(alignment: .leading) {
                HStack {
                    Text(vet.vetFirstName ?? "Not available")
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                    Text(vet.vetLastName ?? "Not available")
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                }
                AddressView(address1: vet.vetAddress1 ?? "", address2: vet.vetAddress2)
                AddressView(address1: vet.vetCity ?? "", address2: vet.vetState)
                Text(vet.vetPhoneNumber ?? "Not provided")
            }
        }
    }
}

#Preview {
    let managedObjectContext = CoreDataStack.shared.context

    let sampleDog = Dog(context: managedObjectContext)
    let sampleVet = VetInformation(context: managedObjectContext)
    sampleVet.vetFirstName = "Test Vet"

    sampleDog.vetRelationship = sampleVet
    sampleVet.vetFirstName = "Dr. Scruffy"
    sampleVet.vetLastName = "McFlufferton"
    sampleVet.vetAddress1 = "123 Pawsome Lane"
    sampleVet.vetAddress2 = "Doghouse 4"
    sampleVet.vetCity = "Treat City"
    sampleVet.vetState = "Ohio"
    sampleVet.vetZip = "48484"
    sampleVet.vetPhoneNumber = "(555) 867-5309"

    sampleDog.vetRelationship = sampleVet
    
    return ViewVetInformation(vet: sampleVet, dog: sampleDog)
        .environmentObject(VetInformationDataStore())

}
