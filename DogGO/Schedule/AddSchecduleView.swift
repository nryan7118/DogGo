//
//  AddScheduleView.swift
//  DogGO
//
//  Created by Nick Ryan on 8/24/24.
//

import SwiftUI
import CoreData

struct AddScheduleView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @EnvironmentObject var scheduleDataStore: ScheduleDataStore
    @Binding var scheduledTimes: Schedule
    
    var dogID: UUID
    
    @State var savedEvents: [Schedule] = []
    @State  var selectedCategory: String = "Select a Category"
    
    var categories = ["Meal", "Medicine", "Walk", "Treat", "Other"]
    let pawPrintFrameLength: CGFloat = 50.0
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
//                    TextField("Event", text: $scheduledTimes.scheduledEvent.bound)
                    TextField("Event", text: .constant("Test Event"))
                        .accessibilityIdentifier("Event")

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
                            await saveEvent(for: dogID)
                        }
                    })
                    {
                        Image(systemName: "pawprint")
                            .resizable()
                            .foregroundColor(Color.accentColor)
                            .frame(width: pawPrintFrameLength, height: pawPrintFrameLength)
                    }
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
                scheduleDataStore.fetchSchedules(for: dogID)
                savedEvents = scheduleDataStore.schedules
                
                if let category = scheduledTimes.scheduledCategory {
                    selectedCategory = category
                }
            }
        }
    }
    
    func saveEvent(for dogID: UUID) async {
        guard let event = scheduledTimes.scheduledEvent, !event.isEmpty else {
            print("Event cannot be empty")
            return
        }
         
        guard selectedCategory != "Select a Category" else {
            print("Category cannot be empty")
            return
        }
         
        scheduledTimes.scheduledCategory = selectedCategory
         
        let newEvent = Schedule(context: managedObjectContext)
        newEvent.scheduledTime = scheduledTimes.scheduledTime ?? Date()
        newEvent.scheduledEvent = event
        newEvent.scheduledCategory = scheduledTimes.scheduledCategory
        newEvent.scheduleID = UUID()
        newEvent.selectedDogID = dogID
         
        await scheduleDataStore.addSchedule(newEvent)
         
        savedEvents.append(newEvent)
         resetForm()
    }
    
    func deleteEvent(_ event: Schedule) async {
        await scheduleDataStore.deleteSchedule(event)
        if let index = savedEvents.firstIndex(of: event) {
            savedEvents.remove(at: index)
        }
    }
    
     func resetForm() {
        scheduledTimes = Schedule(context: managedObjectContext)
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
