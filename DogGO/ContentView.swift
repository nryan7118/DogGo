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
    @State private var showAlert = false

    var body: some View {
        NavigationStack {
            if dogDataStore.dogs.isEmpty {
                FirstDogView(selectedDog: $selectedDog)
            } else {
                List {
                    ForEach(dogDataStore.dogs) { dog in
                        HStack {
                            NavigationLink(destination:
                                            ViewDogTabView(
                                                dog: dog,
                                                vet: selectedVet ?? VetInformation(context: CoreDataStack.shared.context)
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
                        NavigationLink(destination: AddDogProgressiveView(dog: $selectedDog)) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .onAppear {
                    Task {
                        await dogDataStore.fetchDogs()
                    }
                }
                .alert(isPresented: .constant(dogDataStore.alertMessage != nil), content: {
                    Alert(
                title: Text("Error"),
                message: Text(dogDataStore.alertMessage ?? ""),
                dismissButton: .default(Text("OK")) {
                    dogDataStore.alertMessage = nil
                }
                )
                })
            }
        }
    }
    private func deleteDog(offsets: IndexSet) {
        for index in offsets {
            let dog = dogDataStore.dogs[index]
            dogDataStore.deleteDog(dog)
                }
            }
        }

#Preview {
    let dogDataStore = DogDataStore()
    let scheduleDataStore = ScheduleDataStore()
    let vetInformationDataStore = VetInformation()
    
    return ContentView()
        .environmentObject(dogDataStore)
        .environmentObject(scheduleDataStore)
        .environmentObject(vetInformationDataStore)
}
