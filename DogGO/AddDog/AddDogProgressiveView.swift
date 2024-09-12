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
    @State private var step: Int = 1
    
    @State private var name: String = ""
    @State private var dob: Date = Date()
    @State private var breed: String = ""
    @State private var likes: [String] = [""]
    @State private var dislikes: [String] = [""]
    
    @State private var ownerName: [String] = [""]
    @State private var ownerPhone: [String] = [""]
    @State private var emergencyContact: String? = ""
    @State private var emergencyContactPhone: String? = ""
    
    @State private var selectedImageData: Data? = nil
    @State private var selectedVet: VetInformation? = nil
    @State private var scheduledTimes: Schedule = Schedule(context: CoreDataStack.shared.context)
    
    @Binding var dog: Dog?
    
    var body: some View {
        NavigationStack {
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
                        selectedVet: $selectedVet,
                        onNext: {
                            saveVetInfo()
                            step = 4
                        }
                    )

                case 4:
                    AddScheduleView(
                        scheduledTimes: $scheduledTimes,
                        dogID: dog?.dogID ?? UUID()  // Use the dogID once the dog is saved properly
                    )

                default:
                    Text("Invalid Step")
                }
            }
            .navigationTitle(getTitleForStep(step))
            .onAppear {
                if let dogID = dog?.dogID {
                    loadDogInfo(dogID: dogID)  // Only load dog info if a valid dogID exists
                }
            }
        }
    }
    
    private func getTitleForStep(_ step: Int) -> String {
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
    
    private func saveOwnerAndPhoto() {
        guard let dog = fetchLastSavedDog() else { return }

        dog.ownerName = ownerName as NSArray
        dog.ownerPhone = ownerPhone as NSArray
        dog.emergencyContacts = emergencyContact
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
            dog.vetSelectedID = vet.vetID
        } else {
            let newVet = VetInformation(context: CoreDataStack.shared.context)
            newVet.vetID = UUID()
            dog.vetSelectedID = newVet.vetID
        }
        
        CoreDataStack.shared.save()
        print("Vet info saved successfully!")
    }
    
    private func saveSchedule() {
        guard let dog = fetchLastSavedDog() else { return }
        
        let newSchedule = Schedule(context: CoreDataStack.shared.context)
        newSchedule.scheduledTime = scheduledTimes.scheduledTime
        newSchedule.scheduledEvent = scheduledTimes.scheduledEvent
        newSchedule.scheduledCategory = scheduledTimes.scheduledCategory
        newSchedule.scheduleID = UUID()
        newSchedule.selectedDogID = dog.dogID
        
        CoreDataStack.shared.save()
        print("Schedule saved successfully!")
    }
    
    private func fetchLastSavedDog() -> Dog? {
        if let dog = dog {
            return dog
        }
        
        let fetchRequest: NSFetchRequest<Dog> = Dog.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
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
                print("Dog info loaded sucessfully for dogID: \(dogID)")
            } else {
                print("No dog found with the provided dogID: \(dogID)")
            }
        } catch {
            print("Failed to fetch dog with dogID: \(dogID), error: \(error.localizedDescription)")
        }
    }
}

#Preview {
    AddDogProgressiveView(dog: .constant(Dog(context: CoreDataStack.shared.context)))
}
