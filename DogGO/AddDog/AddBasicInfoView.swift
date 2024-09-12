//
//  BasicInfoView.swift
//  DogGO
//
//  Created by Nick Ryan on 8/24/24.
//

import SwiftUI

struct AddBasicInfoView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @EnvironmentObject var dogDataStore: DogDataStore
    @FocusState private var likesTextfieldFocused: Bool
    @FocusState private var dislikesTextfieldFocused: Bool

    @Binding var dog: Dog?
    @Binding var name: String
    @Binding var dob: Date
    @Binding var breed: String
    @Binding var likes: [String]
    @Binding var dislikes: [String]

    @State private var newLike: String = ""
    @State private var newDislikes: String = ""

    var onNext: () -> Void

    var body: some View {
        Form {
            Section(header: Text("Basic Information")) {
                TextEntryRowView(title: "Dog's Name", value: $name)
                    .accessibilityIdentifier("dogNameTextField")
                BreedPickerView(selectedBreed: $breed)
                    .accessibilityIdentifier("breedPicker")
                DatePicker("Date of Birth", selection: $dob, displayedComponents: [.date])
                    .accessibilityIdentifier("dobDatePicker")
                    .datePickerStyle(.graphical)
                    .frame(maxWidth: .infinity)
                    .padding()
            }

            Section(header: Text("Likes & Dislikes")
                .accessibilityIdentifier("likesDislikesSection")) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("Likes")
                            .font(.headline)
                        HStack {
                            TextField("Add new like...", text: $newLike)
                                .onLongPressGesture(minimumDuration: 0.0) {
                                    likesTextfieldFocused = true
                                }
                                .focused($likesTextfieldFocused)
                                .frame(maxWidth: .infinity)

                            Button(action: {
                                let trimmedLike = newLike.trimmingCharacters(in: .whitespacesAndNewlines)
                                if !trimmedLike.isEmpty {
                                    likes.append(trimmedLike)
                                    newLike = ""
                                }
                            }) {
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
                                .onLongPressGesture(minimumDuration: 0.0) {
                                    dislikesTextfieldFocused = true
                                }
                                .focused($dislikesTextfieldFocused)
                                .frame(maxWidth: .infinity)

                            Button(action: {
                                let trimmedDislike = newDislikes.trimmingCharacters(in: .whitespacesAndNewlines)
                                if !trimmedDislike.isEmpty {
                                    dislikes.append(trimmedDislike)
                                    newDislikes = ""
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                            }
                        }
                        ForEach(dislikes, id: \.self) { dislike in
                            Text(dislike)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
            }

            Button(action: saveAndNext) {
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .accessibilityIdentifier("NextButton")  // Ensure we add the accessibility identifier here
            .buttonStyle(.borderedProminent)
        }
        .onAppear(perform: loadDogInfo)
    }

    private func saveAndNext() {
        if dog == nil {
            dog = Dog(context: managedObjectContext)
            dog?.dogID = UUID()
        }

        if dog?.dogID == nil {
            dog?.dogID = UUID()
        }

        dog?.name = name
        dog?.dob = dob
        dog?.breed = breed
        dog?.likes = likes as NSArray
        dog?.dislikes = dislikes as NSArray

        do {
            try managedObjectContext.save()
            Task {
                await dogDataStore.fetchDogs()
            }
        } catch {
            print("Error saving dog info: \(error)")
        }

        onNext()
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
    var dog = Dog(context: CoreDataStack.shared.context)
    var dogDataStore = DogDataStore(managedObjectContext: CoreDataStack.shared.context)
    
  return  AddBasicInfoView(dog: .constant(dog), name: .constant("Test"), dob: .constant(Date()), breed: .constant("Test"), likes: .constant([""]), dislikes: .constant([""]), onNext: {})
}
