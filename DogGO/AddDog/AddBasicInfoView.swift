//
//  BasicInfoView.swift
//  DogGO
//
//  Created by Nick Ryan on 8/24/24.
//

import SwiftUI

struct AddBasicInfoView: View {
    @EnvironmentObject var dogDataStore: DogDataStore
    @Binding var dog: Dog?
    @Binding var name: String
    @Binding var dob: Date
    @Binding var breed: String
    @Binding var likes: [String]
    @Binding var dislikes: [String]

    @State private var newLike: String = ""
    @State private var newDislikes: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var onNext: () -> Void

    var body: some View {
        Form {
            Section("Basic Information") {
                TextEntryRowView(title: "Dog's Name", value: $name)
                    .accessibilityIdentifier("dogNameTextField")
                BreedPickerView(selectedBreed: $breed)
                    .accessibilityIdentifier("breedPicker")
                DatePicker("Date of Birth", selection: $dob, displayedComponents: [.date])
                    .accessibilityIdentifier("dobDatePicker")
                    .datePickerStyle(.graphical)
            }

            Section("Likes & Dislikes") {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("Likes")
                            .font(.headline)
                        HStack {
                            TextField("Add new like...", text: $newLike)

                            Button {
                                let trimmedLike = newLike.trimmingCharacters(in: .whitespacesAndNewlines)
                                if !trimmedLike.isEmpty {
                                    likes.append(trimmedLike)
                                    newLike = ""
                                }
                            } label: {
                                Image(systemName: "plus.circle.fill")
                            }
                        }
                        ForEach(likes, id: \.self) { like in
                            Text(like)
                        }
                    }

                    Divider()

                    VStack(alignment: .leading) {
                        Text("Dislikes")
                            .font(.headline)
                        HStack {
                            TextField("Add new dislike...", text: $newDislikes)

                            Button {
                                let trimmedDislike = newDislikes.trimmingCharacters(in: .whitespacesAndNewlines)
                                if !trimmedDislike.isEmpty {
                                    dislikes.append(trimmedDislike)
                                    newDislikes = ""
                                }
                            } label: {
                                Image(systemName: "plus.circle.fill")
                            }
                            .accessibilityLabel("addButton")
                        }
                        ForEach(dislikes, id: \.self) { dislike in
                            Text(dislike)
                        }
                    }
                }
            }

            Button(action: saveAndNext) {
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .controlSize(.large)
            }
            .accessibilityIdentifier("NextButton")
            .buttonStyle(.borderedProminent)
        }
        .onAppear(perform: loadDogInfo)
        .alert("Error", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }

    private func saveAndNext() {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            alertMessage = "Please enter the dog's name."
            showingAlert = true
            return 
        }

        if dog == nil {
            dog = Dog(context: CoreDataStack.shared.context)
            dog?.dogID = UUID()
        }

        if dog?.dogID == nil {
            dog?.dogID = UUID()
        }

        dog?.name = name
        dog?.dob = dob
        dog?.breed = breed
        dog?.likes = likes as [String] as NSObject
        dog?.dislikes = dislikes as [String] as NSObject

        // Add the dog to the data store
        dogDataStore.addDog(dog!)

        // Async task for fetching dogs and moving to the next step
        Task {
            do {
                await dogDataStore.fetchDogs()
                onNext()  // Proceed to the next step
            }
        }
    }

    private func loadDogInfo() {
        if let dog = dog {
            name = dog.name ?? ""
            dob = dog.dob ?? Date()
            breed = dog.breed ?? ""
            likes = (dog.likes as? [String]) ?? []
            dislikes = (dog.dislikes as? [String]) ?? []
        }
    }
}

#Preview {
    let dog = Dog()
    return  AddBasicInfoView(
        dog: .constant(dog),
        name: .constant("Test"),
        dob: .constant(Date()),
        breed: .constant("Test"),
        likes: .constant([""]),
        dislikes: .constant([""]),
        onNext: {})
}
