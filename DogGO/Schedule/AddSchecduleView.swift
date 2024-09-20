//
//  AddScheduleView.swift
//  DogGO
//
//  Created by Nick Ryan on 8/24/24.
//

import SwiftUI
import CoreData

struct AddScheduleView: View {
    @EnvironmentObject var scheduleDataStore: ScheduleDataStore
    @Binding var scheduledTimes: Schedule

    var dog: Dog

    @State var savedEvents: [Schedule] = []
    @State  var selectedCategory: String = "Select a Category"

    var categories = ["Meal", "Medicine", "Walk", "Treat", "Other"]
    let pawPrintFrameLength: CGFloat = 50.0

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Enter Event", text: $scheduledTimes.scheduledEvent.bound)
                        .accessibilityIdentifier("Event TextField")
                    DropDownView(selectedCategory: $selectedCategory, categories: categories)
                        .accessibilityIdentifier("Select a Category")
                    TimePickerView(selectedTime: $scheduledTimes.scheduledTime)
                        .accessibilityIdentifier("Time Picker")
                }

                HStack {
                    Text("Save Event")
                        .font(.headline)
                    Spacer()
                    Button(action: {
                        Task {
                            await saveEvent(for: dog)
                        }
                    },
                    label: {
                        Image(systemName: "pawprint")
                            .resizable()
                            .foregroundColor(Color.accentColor)
                            .frame(width: pawPrintFrameLength, height: pawPrintFrameLength)
                    })
                    .accessibilityIdentifier("Save Event")

                }
                if !savedEvents.isEmpty {
                    Section(header: Text("Scheduled Events ")) {
                        List {
                            ForEach(savedEvents, id: \.self) { event in
                                VStack(alignment: .leading) {
                                    Text(event.scheduledEvent ?? "Unknown Event")
                                        .font(.headline)
                                    Text(event.scheduledCategory ?? "Unknown Category")
                                        .font(.subheadline)
                                    Text("Time: \(formattedDate(event.scheduledTime ?? Date()))")
                                        .font(.caption)
                                }
                                .swipeActions {
                                    Button(role: .destructive) {
                                        Task {
                                            await deleteEvent(event)
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Schedule Event")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    savedEvents = []
                    await scheduleDataStore.fetchSchedules(for: dog)
                    savedEvents = scheduleDataStore.schedules
                }

                if let category = scheduledTimes.scheduledCategory {
                    selectedCategory = category
                }
            }
            .alert(isPresented: .constant(scheduleDataStore.alertMessage != nil), content: {
                Alert(
                    title: Text("Alert"),
                    message: Text(scheduleDataStore.alertMessage ?? ""),
                    dismissButton: .default(Text("OK")) {
                        scheduleDataStore.alertMessage = nil
                    }
                    )
            })
        }
    }

    func saveEvent(for dog: Dog) async {
        guard let event = scheduledTimes.scheduledEvent, !event.isEmpty else {
            print("Event cannot be empty")
            return
        }

        guard selectedCategory != "Select a Category" else {
            print("Category cannot be empty")
            return
        }

        scheduledTimes.scheduledCategory = selectedCategory

        let newEvent = Schedule(context: CoreDataStack.shared.context)
        newEvent.scheduledTime = scheduledTimes.scheduledTime ?? Date()
        newEvent.scheduledEvent = event
        newEvent.scheduledCategory = scheduledTimes.scheduledCategory
        newEvent.scheduleID = UUID()
        newEvent.dogRelationship = dog

        await scheduleDataStore.addSchedule(newEvent, to: dog)

        if !savedEvents.contains(where: { $0.scheduleID == newEvent.scheduleID }) {
            savedEvents.append(newEvent)
            resetForm()
        }
    }

    func deleteEvent(_ event: Schedule) async {
        await scheduleDataStore.deleteSchedule(event)
        if let index = savedEvents.firstIndex(of: event) {
            savedEvents.remove(at: index)
        }
    }

    func resetForm() {
        scheduledTimes.scheduledEvent = ""
        scheduledTimes.scheduledTime = Date()
        selectedCategory = "Select a Category"
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

extension Binding where Value == String? {
    var bound: Binding<String> {
        return Binding<String>(
            get: { self.wrappedValue ?? "" },
            set: { self.wrappedValue = $0 }
        )
    }
}
