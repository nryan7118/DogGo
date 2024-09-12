//
//  AddressView.swift
//  DogGO
//
//  Created by Nick Ryan on 9/8/24.
//

import SwiftUI

struct AddressView: View {
    var address1: String
    var address2: String?
    
    var body: some View {
        Text(buildAddressText(address1: address1, address2: address2))
            .lineLimit(nil)  // Allow for text wrapping
            .fixedSize(horizontal: false, vertical: true) // Enable wrapping
    }
    
    // Helper function to build the complete address string
    private func buildAddressText(address1: String, address2: String?) -> String {
        if let address2 = address2, !address2.isEmpty {
            return "\(address1), \(address2)"  // Concatenate with comma
        } else {
            return address1  // Return just the first address if no second one
        }
    }
}

#Preview {
    AddressView(address1: "123 Main St", address2: "Apt 4B")
}
