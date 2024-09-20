//  Owner&PhotoView.swift
//  DogGO
//
//  Created by Nick Ryan on 9/4/24.
//

import SwiftUI
import PhotosUI

struct AddOwnerAndPhotoView: View {

    @Binding var ownerName: String
    @Binding var ownerPhone: String
    @Binding var emergencyContact: String?
    @Binding var emergencyContactPhone: String?
    @Binding var selectedImageData: Data?

    @State private var selectedItem: PhotosPickerItem?
    @State private var isImageLoading: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var onSave: () -> Void
    var nextStep: () -> Void

    let photoFrameLength: CGFloat = 250.0
    let buttonWidth: CGFloat = 200.0
    let buttonHeight: CGFloat = 40.0
    let cameraIconLength: CGFloat = 24.0
    let buttonBorderWidth: CGFloat = 2.0

    var body: some View {
        Form {
            Section(header: Text("Owner")) {
                VStack(alignment: .leading) {
                    TextEntryRowView(title: "Owner Name", value: $ownerName)
                        .padding(.bottom, 4)
                        .accessibilityIdentifier("ownerNameTextField")

                    TextEntryRowView(title: "Owner Phone", value: $ownerPhone)
                        .padding(.bottom, 4)
                        .accessibilityIdentifier("ownerPhoneTextField")
                }
            }
            .frame(maxWidth: .infinity)
            Section(header: Text("Emergency Contact")) {
                VStack(alignment: .leading) {
                    TextEntryRowView(title: "Emergency Contact", optionalValue: $emergencyContact)
                        .padding(.bottom, 4)
                        .accessibilityIdentifier("emergencyContactTextField")

                    TextEntryRowView(title: "Emergency Contact Phone", optionalValue: $emergencyContactPhone)
                        .accessibilityIdentifier("emergencyContactPhoneTextField")
                }
            }
            .frame(maxWidth: .infinity)

            Section(header: Text("Dog Photo")) {
                if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Capsule())
                        .frame(width: photoFrameLength, height: photoFrameLength)
                        .frame(maxWidth: .infinity)
                } else if isImageLoading {
                    ProgressView()
                        .frame(width: photoFrameLength, height: photoFrameLength)
                } else {
                    Image("dogPhoto")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Capsule())
                        .frame(width: photoFrameLength, height: photoFrameLength)
                }

                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    HStack {
                        Image(systemName: "camera")
                            .resizable()
                            .scaledToFit()
                            .frame(width: cameraIconLength, height: cameraIconLength)
                            .foregroundColor(.accentColor)
                        Text("Select a photo")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                    }
                    .padding()
                }
                
                .onChange(of: selectedItem) { _, newItem in
                    Task {
                        isImageLoading = true
                        if let newItem = newItem {
                            do {
                                if let data = try await newItem.loadTransferable(type: Data.self) {
                                    selectedImageData = data
                                }
                            } catch {
                                alertMessage = "Error loading image: \(error.localizedDescription)"
                                showAlert = true
                            }
                        }
                            isImageLoading = false
                    }
                }
                .frame(width: buttonWidth, height: buttonHeight)
                .background(Capsule().stroke(Color.accentColor, lineWidth: buttonBorderWidth))
                .accessibilityIdentifier("photoPickerButton")
            }
            .frame(maxWidth: .infinity)

            Button(action: {
                if !isImageLoading {
                    onSave()
                    nextStep()
                }
            }, label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
            })
            .accessibilityIdentifier("saveButton")
            .buttonStyle(.borderedProminent)
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    AddOwnerAndPhotoView(
        ownerName: .constant("Owner Name"),
        ownerPhone: .constant("123-456-7890"),
        emergencyContact: .constant("Emergency Contact"),
        emergencyContactPhone: .constant("987-654-3210"),
        selectedImageData: .constant(nil),
        onSave: {},
        nextStep: {}
    )
}
