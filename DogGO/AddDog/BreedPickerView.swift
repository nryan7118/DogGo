//
//  BreedPickerView.swift
//  DogGO
//
//  Created by Nick Ryan on 9/3/24.
//

import SwiftUI

struct BreedPickerView: View {
    @Binding var selectedBreed: String
    @State private var searchText: String = ""
    @State private var breeds: [String] = []
    @State private var isLoading: Bool = false

    let vstackSpacing: CGFloat = 5.0
    let cornerRadius: CGFloat = 8.0
    let borderWidth: CGFloat = 2.0
    let backgroundCornerRadius: CGFloat = 16.0
    let backgroundLineWidth: CGFloat = 1.0
    let breedPickerFrameHeight: CGFloat = 150

    var body: some View {
        VStack(alignment: .leading, spacing: vstackSpacing) {
            // Search bar to filter breeds
            TextField("Search breeds...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            if isLoading {
                ProgressView("Loading breeds...")
                    .padding()
            } else {
                // Picker to display filtered breeds
                Picker("Select a breed", selection: $selectedBreed) {
                    ForEach(filteredBreeds, id: \.self) { breed in
                        Text(breed).tag(breed)
                    }
                }
                .accessibilityLabel("breedPicker")
                .pickerStyle(WheelPickerStyle())
                .frame(height: breedPickerFrameHeight)
                .background(RoundedRectangle(cornerRadius: backgroundCornerRadius)
                                .stroke(Color.gray, lineWidth: backgroundLineWidth))
                .onChange(of: filteredBreeds) { _, newBreeds in
                    // Ensure the selected breed is still in the filtered list
                    if !newBreeds.contains(selectedBreed) {
                        // Reset to the first breed if the selected one isn't in the filtered list
                        selectedBreed = newBreeds.first ?? ""
                    }
                }
            }
        }
        .onAppear {
            isLoading = true
            fetchBreeds()
        }
    }

    // Filter the breeds based on the search text
    private var filteredBreeds: [String] {
        if searchText.isEmpty {
            return breeds
        } else {
            return breeds.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }

    // Fetch breeds from the API manager
    private func fetchBreeds() {
        DogBreedAPIManager.shared.fetchBreeds { result in
                switch result {
                case .success(let fetchedBreeds):
                    breeds = fetchedBreeds
                case .failure(let error):
                    print("Failed to fetch breeds: \(error)")
                }
                isLoading = false
        }
    }
}

#Preview {
    BreedPickerView(selectedBreed: .constant(""))
}
