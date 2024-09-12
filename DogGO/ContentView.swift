//
//  ContentView.swift
//  DogGO
//
//  Created by Nick Ryan on 8/23/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var dogDataStore: DogDataStore
    @State private var selectedDog: Dog?
    @State private var selectedVet: VetInformation?
    @State private var selectedSchedule: Schedule?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(dogDataStore.dogs) { dog in
                    HStack {
                        NavigationLink(destination:
                                        ViewDogTabView(
                                            dog: dog,
                                            vet: selectedVet ?? VetInformation(context: dogDataStore.managedObjectContext)
                                        )
                        ) {
                            Text(dog.name ?? "No Name")
                        }
                        
                        Spacer()
                    }
                }
                .onDelete(perform: deleteDog)
            }
            .navigationTitle("Dogs")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddDogProgressiveView(dog: $selectedDog))  {
                        Image(systemName: "plus")
                    }
//                    .onTapGesture {
//                        if selectedDog == nil {
//                            selectedDog = Dog(context: dogDataStore.managedObjectContext)
                      //  }
                    }
                }
            }
            .onAppear {
                Task {
                    await dogDataStore.fetchDogs()
                }
            }
        }
//    }
    
    private func deleteDog(offsets: IndexSet) {
        for index in offsets {
            let dog = dogDataStore.dogs[index]
            dogDataStore.deleteDog(dog)
            
                }
            }
        }

#Preview {
    let managedObjectContext = CoreDataStack.shared.context
let dogDataStore = DogDataStore(managedObjectContext: managedObjectContext)
        let scheduleDataStore = ScheduleDataStore(managedObjectContext: managedObjectContext)
    let vetInformationDataStore = VetInformation(context: managedObjectContext)
    
    return ContentView()
        .environmentObject(dogDataStore)
        .environmentObject(scheduleDataStore)
        .environmentObject(vetInformationDataStore)
    
}
