//
//  ArrayEntryView.swift
//  DogGO
//
//  Created by Nick Ryan on 8/24/24.
//

import SwiftUI

struct ArrayEntryView: View {
    @Binding var items: [String]
    @State private var showModal = false
    @State private var newItem: String = ""
    
    var title: String
    
    var body: some View {
    VStack(alignment: .leading, spacing: 10) {
            Text(title)
            .font(.title2)
            .fontWeight(.semibold)
            .fontDesign(.serif)
        ForEach(items.indices, id: \.self) { index in
            HStack {
                Image(systemName: "pawprint.circle.fill")
                Text("\(items[index])")
                    .frame(maxWidth: 200, maxHeight: 40)
                    .background((Color.gray.opacity(0.2)))
                    .border(Color.accentColor)

            }
        }
            Button("Add New Item") {
                showModal.toggle()
            }
            .sheet(isPresented: $showModal) {
                VStack {
                    TextField("New Item", text: $newItem)
                        
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                    Button("Save") {
                        addItem()
                        showModal = false
                    }
                    .padding()
                }
               // .padding()
            }
        }
        .padding()
    }
    private func addItem() {
        withAnimation {
            if !newItem.isEmpty {
                items.append(newItem)
                newItem = ""
            }
        }
    }
}

#Preview {
    ArrayEntryView(items: .constant(["Belly Rubs"]), title: "Likes")
}
