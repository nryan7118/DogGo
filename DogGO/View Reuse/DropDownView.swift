import SwiftUI

struct DropDownView: View {
    @Binding var selectedCategory: String
    var categories: [String]
    
    var body: some View {
        VStack {
            Picker(selection: $selectedCategory, label: Text(selectedCategory)) {
                Text("Select a Category").tag("Select a Category" as String)
                ForEach(categories, id: \.self) { category in
                    Text(category).tag(category as String)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
}

#Preview {
    DropDownView(selectedCategory: .constant(""), categories: ["Meal Time", "Potty Break", "Treat Time", "Play Time"])
}
