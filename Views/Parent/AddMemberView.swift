//
//  AddMemberView.swift
//  KoungaFamilyChoreRewards
//
//  Created by Anjana Kulasinghe on 10/04/2025.
//

import SwiftUI

struct AddMemberView: View {
    @EnvironmentObject var familyVM: FamilyViewModel
    @Binding var email: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Member Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                Section {
                    Button("Add Member") {
                        familyVM.addMember(email: email)
                        dismiss()
                    }
                    .disabled(email.isEmpty || !email.contains("@"))
                }
            }
            .navigationTitle("Add Family Member")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
