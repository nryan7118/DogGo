//
//  OwnerInformationSectionView.swift
//  DogGO
//
//  Created by Nick Ryan on 9/7/24.
//

import SwiftUI

struct OwnerInformationSectionView: View {
    var dog: Dog
    
    let imageSize: CGFloat = 100.0
    
    var body: some View {
        HStack {
            Image("dogHouse")
                .resizable()
                .frame(maxWidth: imageSize, maxHeight: imageSize)
            Spacer()
            VStack(alignment: .leading) {
                Text((dog.ownerName as? [String])?.joined(separator: ", ") ?? "No name")
                Text((dog.ownerPhone as? [String])?.joined(separator: ", ") ?? "No phone")
            }
        }
        .padding()
    }
}

#Preview {
    let managedObjectContext = CoreDataStack.shared.context
    
    let sampleDog = Dog(context: managedObjectContext)
    sampleDog.ownerName = ["Joe Blow", "Jane Doe"] as NSObject
    sampleDog.ownerPhone = ["123-456-7890", "987-654-3210"] as NSObject
    
    return OwnerInformationSectionView(dog: sampleDog)
}


