//
//  AddDogPhotoView.swift
//  DogGO
//
//  Created by Nick Ryan on 8/31/24.
//

import SwiftUI
import PhotosUI

struct AddDogPhotoView: View {
    @Binding var selectedImageData: Data?
    @State private var selectedItem: PhotosPickerItem? = nil
    
    let vStackSpacing: CGFloat = 20.0
    let frameLengthCapsule: CGFloat = 300.0
    let backgroundOpacity: CGFloat = 0.3
    let strokeBorderWidth: CGFloat = 4.0
    let shadowOpacity: CGFloat = 0.5
    let shadowRadius: CGFloat = 10.0
    let shadowX: CGFloat = 0
    let shadowY: CGFloat = 5.0
    let frameLength: CGFloat = 260.0
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(spacing: vStackSpacing) {
                        ZStack {
                            Capsule()
                                .strokeBorder(Color.accentColor, lineWidth: strokeBorderWidth)
                                .background(Capsule().fill(Color.white.opacity(backgroundOpacity)))
                                .frame(width: frameLengthCapsule, height: frameLengthCapsule)
                                .shadow(
                                    color: Color.gray.opacity(shadowOpacity),
                                        radius: shadowRadius, x: shadowX, y: shadowY)
                            
                            if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Capsule())
                                    .frame(width: frameLength, height: frameLength)
                                    .frame(maxWidth: .infinity)
                            } else {
                                Image("dogPhoto")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Capsule())
                                    .frame(width: frameLength, height: frameLength)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
                
            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                Text("Select a photo")
                    .font(.headline)
                    .foregroundColor(.accentColor)
            }
        }
            .onChange(of: selectedItem) { oldItem, newItem in
                if let selectedImage = newItem {
                    Task {
                        if let data = try? await selectedImage.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
            }
                .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        selectedImageData = nil
                    }
                }
            }
        }
    }
}
