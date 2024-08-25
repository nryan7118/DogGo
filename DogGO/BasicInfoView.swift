//
//  BasicInfoView.swift
//  DogGO
//
//  Created by Nick Ryan on 8/24/24.
//

import SwiftUI

struct BasicInfoView: View {
    @Binding var name: String
    @Binding var breed: String
    @Binding var dob: Date
    @Binding var likes: [String]
    @Binding var dislikes: [String]
    
    
    var body: some View {
        Form{
            Section("Basic Information") {
                TextEntryRowView(title: "Dog's Name", value: $name)
                TextEntryRowView(title: "Breed", value: $breed)
                HStack {
                    DatePicker(" Date of Birth", selection: $dob, displayedComponents: .date)
                        .padding(.horizontal)
                    Image(systemName: "pawprint")
                        .resizable()
                        .frame(width: 30, height: 30 )
                        .padding(.horizontal)
                }
                
            }
                Section("Likes and Dislikes") {
                    HStack {
                    ArrayEntryView(items: $likes, title: "Likes")
                        Spacer()
                    ArrayEntryView(items: $dislikes, title: "Dislikes")
                }
            }
        }
    }
}

#Preview {
    BasicInfoView(name: .constant("Kobe"), breed: .constant( "Mini Snauzer"), dob: .constant(Date()), likes: .constant(["Belly Rubs"]), dislikes: .constant(["Loud beeps"]))
}
