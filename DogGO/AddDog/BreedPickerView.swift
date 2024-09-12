//
//  BreedPickerView.swift
//  DogGO
//
//  Created by Nick Ryan on 9/3/24.
//

import SwiftUI

struct BreedPickerView: View {
    @Binding var selectedBreed: String
    @State private var isDropdownOpen: Bool = false
    @State private var searchText: String = ""
    @State private var breeds: [String] = []
    @State private var isLoading: Bool = false
    
    let vstackSpacing: CGFloat = 5.0
    let cornerRadius: CGFloat = 8.0
    let borderWidth: CGFloat = 2.0
    let breedVerticalPadding: CGFloat = 5.0
    let frameHeight: CGFloat = 150.0
    let backgroundCornerRadius: CGFloat = 16.0
    let backgroundLineWidth: CGFloat = 1.0
    
    var body: some View {
        VStackLayout(alignment: .leading, spacing: vstackSpacing) {
            HStack {
                Button(action: {
                    withAnimation {
                        isDropdownOpen.toggle()
                    }
                }) {
                    HStack {
                        Text(selectedBreed.isEmpty ? "Select a breed" : selectedBreed)
                            .foregroundStyle(Color("fontColor"))
                        Spacer()
                        Image(systemName: isDropdownOpen ? "chevron.up" : "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: cornerRadius).stroke(Color.accentColor, lineWidth: borderWidth))
                }
            }
            
            if isDropdownOpen {
                VStack {
                    TextField("Search breeds...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    if isLoading {
                        ProgressView("Loading breeds...")
                            .padding()
                    } else {
                        ScrollView {
                            VStack(alignment: .leading) {
                                ForEach(filteredBreeds, id: \.self) { breed in
                                    Text(breed)
                                        .padding(.vertical, breedVerticalPadding)
                                        .padding(.horizontal)
                                        .onTapGesture {
                                            withAnimation {
                                                selectedBreed = breed
                                                isDropdownOpen = false
                                            }
                                        }
                                }
                            }
                        }
                        .frame(height: frameHeight)
                    }
                }
                .background(RoundedRectangle(cornerRadius: backgroundCornerRadius).stroke(Color.gray, lineWidth: backgroundLineWidth))
            }
        }
        .onAppear {
            isLoading = true
            fetchBreeds()
        }
    }
    
    
    private var filteredBreeds: [String] {
        if searchText.isEmpty {
            return breeds
        } else {
            return breeds.filter { $0.localizedCaseInsensitiveContains(searchText)}
        }
    }
    
    private func fetchBreeds() {
        DogBreedAPIManager.shared.fetchBreeds { result in
            DispatchQueue.main.async {
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
}

#Preview {
    BreedPickerView(selectedBreed: .constant(""))
}

