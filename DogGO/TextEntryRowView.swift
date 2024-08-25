//
//  TextEntryRowView.swift
//  DogGO
//
//  Created by Nick Ryan on 8/24/24.
//

import SwiftUI

struct TextEntryRowView: View {
    var title: String = ""
    @Binding var value: String
    
    
    
    var body: some View {
        HStack() {
            Text(title)
                .font(.body)
                .foregroundStyle(.black)
                .fontDesign(.rounded)
                .fontWeight(.light)
                .padding()

            Spacer()
            TextField(title, text: $value)
            
                .font(.body)
                .fontDesign(.serif)
                .padding()
                .frame(maxWidth: 200, maxHeight: 40)
                .background((Color.gray.opacity(0.2)))
                .border(Color.accentColor)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    TextEntryRowView(title: "Dog's Name: ", value: .constant("Kobe"))
}
