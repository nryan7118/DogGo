//
//  EmergencyContactSectionView.swift
//  DogGO
//
//  Created by Nick Ryan on 9/7/24.
//

import SwiftUI

struct EmergencyContactSectionView: View {
    var dog: Dog

    let imageSize: CGFloat = 100.0

    var body: some View {
        HStack {
            Image("emergencyContact")
                .resizable()
                .frame(maxWidth: imageSize, maxHeight: imageSize)
            Spacer()

            VStack(alignment: .leading) {
                Text(dog.emergencyContact ?? "The Cat")
                    .font(.subheadline)
                Text(dog.emergencyContactPhone ?? "The bell")
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    let managedObjectContext = CoreDataStack.shared.context

    let sampleDog = Dog(context: managedObjectContext)
    sampleDog.emergencyContact = "Grandpa"
    sampleDog.emergencyContactPhone = "(931)239-3941"

    return EmergencyContactSectionView(dog: sampleDog)
}
