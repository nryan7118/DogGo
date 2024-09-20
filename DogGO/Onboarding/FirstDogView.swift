//
//  firstDogView.swift
//  DogGO
//
//  Created by Nick Ryan on 9/17/24.
//

import SwiftUI

struct FirstDogView: View {
    @Binding var selectedDog: Dog?

    var body: some View {
        VStack {
            Text("""
                To get started,
                tap below to add
                your first furry friend.
                """)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .multilineTextAlignment(.center)
            .lineLimit(nil)

            NavigationLink(destination: AddDogProgressiveView(dog: $selectedDog), label: {
                Label("Add Dog", systemImage: "pawprint")
                    .font(.body)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(8.0)
            }
            )
            Image("emptyView")
                .resizable()
                .frame(width: 300, height: 300)
        }

        .frame(maxWidth: .infinity)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.gray))
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    FirstDogView(selectedDog: .constant(Dog(context: CoreDataStack.shared.context)))
}
