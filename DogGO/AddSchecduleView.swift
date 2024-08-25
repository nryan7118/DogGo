//
//  AddSchecduleView.swift
//  DogGO
//
//  Created by Nick Ryan on 8/24/24.
//

import SwiftUI

struct AddScheduleView: View {
    @Binding var scheduledEvent: [String]
    @Binding var scheduledTime: [String]
    
    var body: some View {
        Text("Hello World")
    }
}
    #Preview {
        
        AddScheduleView(scheduledEvent: .constant(["Morning feed"]), scheduledTime: .constant(["8 AM"]))
}
