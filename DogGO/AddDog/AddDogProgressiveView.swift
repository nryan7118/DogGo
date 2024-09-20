//
//  SwiftUIView.swift
//  DogGO
//
//  Created by Nick Ryan on 9/5/24.
//

import SwiftUI
import CoreData

struct AddDogProgressiveView: View {
    @EnvironmentObject var dogDataStore: DogDataStore
    @Environment(\.presentationMode) var presentationMode

    @State private var step = 1

    @State private var name = ""
    @State private var dob = Date()
    @State private var breed = ""
    @State private var likes = [""]
    @State private var dislikes = [""]

    @State private var ownerName = ""
    @State private var ownerPhone = ""
    @State private var emergencyContact: String? = ""
    @State private var emergencyContactPhone: String? = ""

    @State private var selectedImageData: Data?

    @State private var selectedVet: VetInformation?

    @State private var scheduledTimes: Schedule = Schedule(context: CoreDataStack.shared.context)

    @Binding var dog: Dog?

    var body: some View {
        VStack {
            switch step {
            case 1:
                AddBasicInfoView(
                    dog: $dog,
                    name: $name,
                    dob: $dob,
                    breed: $breed,
                    likes: $likes,
                    dislikes: $dislikes,
                    onNext: {
                        if dog == nil {
                            dog = Dog(context: CoreDataStack.shared.context)
                            dog?.dogID = UUID()
                        }
                        saveBasicInfo()
                        step = 2
                    }
                )
            case 2:
                AddOwnerAndPhotoView(
                    ownerName: $ownerName,
                    ownerPhone: $ownerPhone,
                    emergencyContact: $emergencyContact,
                    emergencyContactPhone: $emergencyContactPhone,
                    selectedImageData: $selectedImageData,
                    onSave: saveOwnerAndPhoto,
                    nextStep: {
                        step = 3
                    }
                )
            case 3:
                AddVetInformationView(
                    dog: $dog, selectedVet: $selectedVet,
                    onNext: {

                        saveVetInfo()
                        step = 4
                    }
                )
            case 4:
                AddScheduleView(scheduledTimes: $scheduledTimes, dog: dog ?? Dog(context: CoreDataStack.shared.context))

                HStack {
                    Button("Go Home") {
                        Task {
                            await finishScheduling()
                        }
                        }
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }

            default:
                Text("Invalid Step")
            }
        }
        .navigationTitle(getTitleForStep)
        .onAppear {
            if let dogID = dog?.dogID {
                loadDogInfo(dogID: dogID)
            }
        }
    }

    private var getTitleForStep: String {
        switch step {
        case 1: return "Basic Info"
        case 2: return "Owner & Info"
        case 3: return "Vet Info"
        case 4: return "Schedule"
        default: return ""
        }
    }

    private func saveBasicInfo() {
        guard let dog = dog else { return }
        if !name.isEmpty {
            dog.name = name
            dog.dob = dob
            dog.breed = breed
            dog.likes = likes as NSObject
            dog.dislikes = dislikes as NSObject
            CoreDataStack.shared.save()

            print("Dog saved successfully!")
        } else {
            print("Cannot save. Name is empty.")
        }
    }
    private func resetForNewDog() {
        dog = nil
        name = ""
        dob = Date()
        breed = ""
        likes = [""]
        dislikes = [""]
        ownerName = ""
        ownerPhone = ""
        emergencyContact = ""
        emergencyContactPhone = ""
        selectedImageData = nil
        selectedVet = nil
        scheduledTimes = Schedule(context: CoreDataStack.shared.context)

        step = 1
    }

    private func saveOwnerAndPhoto() {
        guard let dog = fetchLastSavedDog() else { return }

        dog.ownerName = ownerName
        dog.ownerPhone = ownerPhone
        dog.emergencyContact = emergencyContact
        dog.emergencyContactPhone = emergencyContactPhone

        if let imageData = selectedImageData {
            dog.photo = imageData
        }

        CoreDataStack.shared.save()
        print("Owner and photo saved successfully!")
    }

    private func saveVetInfo() {
        guard let dog = fetchLastSavedDog() else { return }

        if let vet = selectedVet {
            dog.vetRelationship = vet
        } else {
            print("No vet selected. Please select a vet to continue.")
        }
        Task {
            CoreDataStack.shared.save()
        }
    }
    private func saveSchedule() {
        guard let dog = fetchLastSavedDog() else { return }

        let newSchedule = Schedule(context: CoreDataStack.shared.context)
        newSchedule.scheduledTime = scheduledTimes.scheduledTime
        newSchedule.scheduledEvent = scheduledTimes.scheduledEvent
        newSchedule.scheduledCategory = scheduledTimes.scheduledCategory
        newSchedule.scheduleID = UUID()

        newSchedule.dogRelationship = dog
        dog.addToScheduleRelationship(newSchedule)
        CoreDataStack.shared.save()
        print("Schedule saved successfully!")
    }

    private func finishScheduling() async {
        resetForNewDog()

        presentationMode.wrappedValue.dismiss()
    }

    private func fetchLastSavedDog() -> Dog? {
        if let dog = dog {
            return dog
        }

        let fetchRequest: NSFetchRequest<Dog> = Dog.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "ownerName", ascending: false)]
        fetchRequest.fetchLimit = 1

        do {
            let result = try CoreDataStack.shared.context.fetch(fetchRequest)
            return result.first
        } catch {
            print("Failed to fetch dog: \(error.localizedDescription)")
            return nil
        }
    }

    private func loadDogInfo(dogID: UUID?) {
        guard let dogID = dogID else {
            print("DogID is nil, cannot load dog info")
            return
        }

        let fetchRequest: NSFetchRequest<Dog> = Dog.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dogID == %@", dogID as CVarArg)

        do {
            let fetchedDogs = try CoreDataStack.shared.context.fetch(fetchRequest)
            if let fetchedDog = fetchedDogs.first {
                self.dog = fetchedDog
                self.name = fetchedDog.name ?? ""
                self.dob = fetchedDog.dob ?? Date()
                self.breed = fetchedDog.breed ?? ""
                self.likes = fetchedDog.likes as? [String] ?? []
                self.dislikes = fetchedDog.dislikes as? [String] ?? []
                print("Dog info loaded successfully for dogID: \(dogID)")
            } else {
                print("No dog found with the provided dogID: \(dogID)")
            }
        } catch {
            print("Failed to fetch dog with dogID: \(dogID), error: \(error.localizedDescription)")
        }
    }
}

#Preview {
    NavigationStack {
        AddDogProgressiveView(dog: .constant(Dog(context: CoreDataStack.shared.context)))
    }
}
