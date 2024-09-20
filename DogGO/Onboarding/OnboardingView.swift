//
//  OnboardingView.swift
//  DogGO
//
//  Created by Nick Ryan on 9/10/24.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var currentPage = 0
    private let totalPages = 4

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
            OnboardingPageView(
                imageName: "logo",
                title: "Welcome to DogGO",
                description: "A place for you and your best friend.")
                .tag(0)

                OnboardingPageView(
                    imageName: "manageDog",
                    title: "Manage Your Dog",
                    description: "Create and manage profiles for all your dogs.")
                    .tag(1)
                OnboardingPageView(
                    imageName: "scheduleIntro",
                    title: "Track Schedules",
                    description: "Set up schedules for feeding, walking, and more.")
                    .tag(2)
            OnboardingPageView(
                imageName: "vetIntro",
                title: "Add Your Vets Invormation",
                description: "Keep all important vet information at hand.")
                    .tag(3)
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))

        HStack {
            if currentPage > 0 {
                Button(action: {
                    currentPage -= 1
                }, label: {
                    Text("Back")
                        .padding()
                })
            }

            Spacer()

            Button(action: {
                        if currentPage < totalPages - 1 {
                            currentPage += 1
                        } else {
                            // Set onboarding as complete
                            UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                            hasSeenOnboarding = true // Dismiss onboarding
                        }
            }, label: {
                        Text(currentPage == totalPages - 1 ? "Finish" : "Next")
                            .padding()
                    })
                }
                .padding(.horizontal)
            }
        }
    }

    #Preview {
        OnboardingView(hasSeenOnboarding: .constant(false))
    }
