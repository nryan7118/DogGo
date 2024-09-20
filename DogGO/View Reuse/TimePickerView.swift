//
//  TimePickerView.swift
//  DogGO
//
//  Created by Nick Ryan on 8/25/24.
//

import SwiftUI

struct TimePickerView: View {
    @Binding var selectedTime: Date?

    let padding: CGFloat = 10.0
    var body: some View {
        HStack(alignment: .center) {
            Text("Select Time")
                .font(.headline)
            Spacer()
            DatePicker("Time", selection: Binding <Date>(
                get: { selectedTime ?? Date() },
                set: {  newValue in
                    selectedTime = newValue }
                ),
                       
            displayedComponents: .hourAndMinute
                )
                .labelsHidden()
                .padding(.top, padding)
                .datePickerStyle(.graphical)
        }
        .padding()
    }
    }

#Preview {
    TimePickerView(selectedTime: .constant(Date()))
}
