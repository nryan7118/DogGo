//
//  ContentView.swift
//  DogGO
//
//  Created by Nick Ryan on 8/23/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var dogs: [Dog]

    var body: some View {
        NavigationStack {
            List {
                ForEach(dogs) { dog in
                    NavigationLink {
                     //   DogDetailView(dog: dog)
                    } label: {
                        Text(dog.name)
                    }
                }
                .onDelete(perform: deleteDogs)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: AddDog()) {
                        Label("Add Dog", systemImage: "plus")
                    }
                }
            }
        }
    }
                private func deleteDogs(offsets: IndexSet) {
                    withAnimation {
                        for index in offsets {
                            modelContext.delete(dogs[index])
                        }
                    }
            }
            }
        

#Preview {
    ContentView()
        .modelContainer(for: Dog.self, inMemory: true)
}
