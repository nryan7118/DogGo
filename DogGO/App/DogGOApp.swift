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
    @StateObject private var dogDataStore = DogDataStore()
    @StateObject private var scheduleDataStore = ScheduleDataStore()
    @StateObject private var vetInformationDataStore = VetInformationDataStore()
    @State private var hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")

    init() {
        CoreDataStack.shared.setupAutomaticSaving()
    }

    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                ContentView()
                    .environmentObject(dogDataStore)
                    .environmentObject(scheduleDataStore)
                    .environmentObject(vetInformationDataStore)
            } else {
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                    .onDisappear {
                        // Ensure UserDefaults is updated after onboarding is completed
                        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                    }
            }
        }
    }
}
