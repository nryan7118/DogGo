//
//  ViewDogInformationView.swift
//  DogGO
//
//  Created by Nick Ryan on 8/28/24.
//

import SwiftUI
import SwiftData

struct ViewDogInformationView: View {
    var dog: Dog

    let photoFrameLength: CGFloat = 200.0
    let vstackSpacking: CGFloat = 10.0
    let overlayStrokeWidth: CGFloat = 4.0
    let shadowRadius: CGFloat = 10.0
    let photoPadding: CGFloat = 20.0
    let textPadding: CGFloat = 5.0

    var body: some View {
        VStack(spacing: vstackSpacking) {
            HighLightedHeadline(value: dog.name ?? "No name available", imageString: "collarPhoto")

            if let photoData = dog.photo, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: photoFrameLength, height: photoFrameLength)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: overlayStrokeWidth))
                    .shadow(radius: shadowRadius)
                    .padding(.bottom, photoPadding)
            } else {
                Image("defaultDogPhoto")
                    .resizable()
                    .scaledToFit()
                    .frame(width: photoFrameLength, height: photoFrameLength)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: overlayStrokeWidth))
                    .shadow(radius: shadowRadius)
                    .padding(.bottom, photoPadding)
            }
            Spacer()
            Form {
                Text("Breed: \(dog.breed ?? "Unknown Breed")")
                    .font(.headline)
                    .padding(.top, textPadding)
                Text("Date of Birth: \(dog.dob != nil ? formattedDate(dog.dob!) : "Unknown DOB")")
                Text("Likes: \((dog.likes as? [String])?.filter { !$0.isEmpty }.joined(separator: ", ") ?? "None")")
                    .padding(.top, textPadding)
                Text("Dislikes: \((dog.dislikes as? [String])?.filter{ !$0.isEmpty }.joined(separator: ", ") ?? "I'm a happy, happy dog.")")
                Text("Special Instructions: \(dog.specialInstructions ?? "None" )")
                    .padding(.top, textPadding)
            }
        }
            .padding()
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    let managedObjectContext = CoreDataStack.shared.context

    let sampleDog = Dog(context: managedObjectContext)
    sampleDog.name = "Kobe"
    sampleDog.breed = "Mini Schnauzer"
    sampleDog.dob = Date()
    sampleDog.likes = ["Belly Rubs", "Running"] as NSObject
    sampleDog.dislikes = ["Loud Noises"] as NSObject
    sampleDog.emergencyContact = "123-867-5309"
    sampleDog.specialInstructions = "Needs extra car during storms"

    return ViewDogInformationView(dog: sampleDog)
}
