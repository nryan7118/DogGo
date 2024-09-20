//
//  TextEntryRowView.swift
//  DogGO
//
//  Created by Nick Ryan on 8/24/24.
//

import SwiftUI

struct TextEntryRowView: View {
    var title: String
    @Binding var value: String

    var height: CGFloat = 40.0
    var opacity: CGFloat = 0.2
    var borderWdith: CGFloat = 2.0
    @FocusState private var textfieldFocused: Bool

    var body: some View {
            TextField(title, text: $value)
                .font(.body)
                .fontDesign(.serif)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: height)
                .border(Color.accentColor, width: borderWdith)
                .background(Color.gray.opacity(opacity))
                .accessibilityIdentifier(title)
        .autocorrectionDisabled()
    }
}

extension TextEntryRowView {
    init(title: String, optionalValue: Binding<String?>) {
        self.title = title
        self._value = Binding(
            get: {optionalValue.wrappedValue ?? " " },
            set: {optionalValue.wrappedValue = $0.isEmpty ? nil : $0 }
            )
        }
    }

#Preview {
    TextEntryRowView(title: "Dog's Name: ", value: .constant("Kobe"))
}
