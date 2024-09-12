//
//  DogGOApp.swift
//  DogGO
//
//  Created by Nick Ryan on 8/23/24.
//

import SwiftUI
import CoreData

@main
struct DogGOApp: App {
    @StateObject private var dogDataStore: DogDataStore
    @StateObject private var scheduleDataStore: ScheduleDataStore
    @StateObject private var vetInformationDataStore: VetInformationDataStore
    @State private var hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")

    
    init() {
        
        let context = CoreDataStack.shared.context
        _dogDataStore = StateObject(wrappedValue: DogDataStore(managedObjectContext: context))
        _scheduleDataStore = StateObject(wrappedValue: ScheduleDataStore(managedObjectContext: context))
        _vetInformationDataStore = StateObject(wrappedValue: VetInformationDataStore(managedObjectContext: context))
        
        CoreDataStack.shared.setupAutomaticSaving()
    }
    
    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                ContentView()
                    .environment(\.managedObjectContext, CoreDataStack.shared.context)  // Provide the managed object context via the environment.
                    .environmentObject(dogDataStore)
                    .environmentObject(scheduleDataStore)
                    .environmentObject(vetInformationDataStore)
            } else {
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
            }
        }
    }
}
