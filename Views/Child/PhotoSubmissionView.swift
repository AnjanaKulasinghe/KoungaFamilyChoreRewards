//
//  PhotoSubmissionView.swift
//  KoungaFamilyChoreRewards
//
//  Created by Anjana Kulasinghe on 10/04/2025.
//

import SwiftUI
import FirebaseStorage
import PhotosUI

struct PhotoSubmissionView: View {
    @EnvironmentObject var familyVM: FamilyViewModel
    @Environment(\.dismiss) var dismiss
    let chore: Chore
    
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var uploadProgress: Double = 0
    @State private var isUploading = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 300)
                        .cornerRadius(12)
                    
                    if isUploading {
                        VStack {
                            ProgressView(value: uploadProgress, total: 1)
                                .padding(.horizontal)
                            Text("Uploading... \(Int(uploadProgress * 100))%")
                                .font(.caption)
                        }
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .foregroundColor(.gray)
                        .padding()
                }
                
                Button {
                    showingImagePicker = true
                } label: {
                    Label(selectedImage == nil ? "Select Photo" : "Change Photo",
                          systemImage: "photo")
                }
                .buttonStyle(.bordered)
                
                if selectedImage != nil {
                    Button("Submit Chore") {
                        uploadPhoto()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isUploading)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Submit Proof")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $selectedImage)
            }
        }
    }
    
    private func uploadPhoto() {
        guard let image = selectedImage,
              let imageData = image.jpegData(compressionQuality: 0.7) else {
            return
        }
        
        isUploading = true
        let storageRef = Storage.storage().reference()
        let choreImageRef = storageRef.child("chore_submissions/\(chore.id ?? UUID().uuidString).jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let uploadTask = choreImageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                familyVM.error = .storage(error.localizedDescription)
                isUploading = false
                return
            }
            
            choreImageRef.downloadURL { url, error in
                if let error = error {
                    familyVM.error = .storage(error.localizedDescription)
                } else if let url = url {
                    familyVM.submitChoreCompletion(choreID: chore.id ?? "", photoURL: url.absoluteString)
                }
                isUploading = false
                dismiss()
            }
        }
        
        uploadTask.observe(.progress) { snapshot in
            uploadProgress = Double(snapshot.progress?.completedUnitCount ?? 0) /
                           Double(snapshot.progress?.totalUnitCount ?? 1)
        }
    }
}
