//
//  OwnerInformationSectionView.swift
//  DogGO
//
//  Created by Nick Ryan on 9/7/24.
//

import SwiftUI

struct OwnerInformationSectionView: View {
    var dog: Dog

    let imageSize = 100.0

    var body: some View {
        HStack {
            Image("dogHouse")
                .resizable()
                .frame(maxWidth: imageSize, maxHeight: imageSize)
            Spacer()
            VStack(alignment: .leading) {
                Text(dog.ownerName ?? "Not available.")
                Text(dog.ownerPhone ?? "Not available")
            }
        }
    }
}

#Preview {
    let managedObjectContext = CoreDataStack.shared.context

    let sampleDog = Dog(context: managedObjectContext)
    sampleDog.ownerName = "Joe Blow"
    sampleDog.ownerPhone = "123-456-7890"
    
    return OwnerInformationSectionView(dog: sampleDog)
}
