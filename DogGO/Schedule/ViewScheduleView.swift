//
//  ViewScheduleView.swift
//  DogGO
//
//  Created by Nick Ryan on 8/31/24.
//

import SwiftUI
import CoreData

struct ViewScheduleView: View {
    @EnvironmentObject var scheduleDataStore: ScheduleDataStore  // Use ScheduleDataStore to manage schedules
    var dog: Dog

    @State private var isShowingAlert = false
    let categoryImageFrameLength: CGFloat = 60.0

    var body: some View {
        NavigationStack {
            if scheduleDataStore.schedules.isEmpty {
                Text("No events found for \(dog.name ?? "Unknown Dog")")
                    .foregroundStyle(Color.gray)
                    .padding()
            } else {
                List(scheduleDataStore.schedules) { schedule in
                    HStack {
                        if let category = schedule.scheduledCategory, !category.isEmpty {
                            categoryImage(for: category)
                                .resizable()
                                .scaledToFit()
                                .frame(width: categoryImageFrameLength, height: categoryImageFrameLength)
                        } else {
                            Image("pawPrint")
                                .resizable()
                                .scaledToFit()
                                .frame(width: categoryImageFrameLength, height: categoryImageFrameLength)
                        }

                        VStack(alignment: .leading) {
                            Text(schedule.scheduledEvent ?? "No Title")
                                .font(.headline)
                                .fontWeight(.medium)
                            if let scheduledTime = schedule.scheduledTime {
                                Text(formatDate(scheduledTime))
                                    .font(.subheadline)
                                    .fontWeight(.thin)
                                    .fontDesign(.monospaced)
                            } else {
                                Text("No scheduled time available")
                                    .font(.subheadline)
                                    .foregroundStyle(Color.gray)
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle("\(dog.name ?? "Unknown Dog")'s Day")
                .onAppear {
                    Task {
                        await scheduleDataStore.fetchSchedules(for: dog)
                    }
                }
            }
        }
                        .onChange(of: scheduleDataStore.alertMessage) { _, newValue in
                            if newValue != nil {
                                isShowingAlert = true
                            }
                        }
                        .alert(isPresented: $isShowingAlert, content: {
                            Alert(
                                title: Text("Error"),
                                message: Text(scheduleDataStore.alertMessage ?? ""),
                                dismissButton: .default(Text("OK")) {
                                    scheduleDataStore.alertMessage = nil
                                })
                        }
                        )
                }

        private func categoryImage(for category: String) -> Image {
            switch category {
            case "Meal":
                return Image("dogBowl")
            case "Medicine":
                return Image("dogPills")
            case "Walk":
                return Image("dogWalk")
            case "Treat":
                return Image("dogTreat")
            case "Other":
                return Image("pawPrint")
            default:
                return Image("pawPrint")
            }
        }

        private func formatDate(_ date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .none
            return dateFormatter.string(from: date)
        }
}

    #Preview {
        let managedObjectContext = CoreDataStack.shared.context

        // Sample Dog for Preview
        let sampleDog = Dog(context: managedObjectContext)
        sampleDog.name = "Buddy"
        sampleDog.dogID = UUID()  // Assign a unique UUID to the dog

        // Create multiple sample schedules
        let schedule1 = Schedule(context: managedObjectContext)
        schedule1.scheduledTime = Date()
        schedule1.scheduledEvent = "Morning Walk"
        schedule1.scheduledCategory = "Walk"
        schedule1.dogRelationship = sampleDog  // Associate the schedule with the dog

        let schedule2 = Schedule(context: managedObjectContext)
        schedule2.scheduledTime = Calendar.current.date(byAdding: .hour, value: 2, to: Date())!
        schedule2.scheduledEvent = "Meal Time"
        schedule2.scheduledCategory = "Meal"
        schedule2.dogRelationship = sampleDog

        let schedule3 = Schedule(context: managedObjectContext)
        schedule3.scheduledTime = Calendar.current.date(byAdding: .hour, value: 4, to: Date())!
        schedule3.scheduledEvent = "Treat Time"
        schedule3.scheduledCategory = "Treat"
        schedule3.dogRelationship = sampleDog

        // Initialize a ScheduleDataStore with the sample schedules
        let scheduleDataStore = ScheduleDataStore()
        scheduleDataStore.schedules = [schedule1, schedule2, schedule3]  // Add the schedules to the store

        return ViewScheduleView(dog: sampleDog)
            .environment(\.managedObjectContext, managedObjectContext)
            .environmentObject(scheduleDataStore)  // Inject the ScheduleDataStore as an environment object
    }
