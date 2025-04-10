//
//  AddChoreView.swift
//  KoungaFamilyChoreRewards
//
//  Created by Anjana Kulasinghe on 10/04/2025.
//

import SwiftUI
import FirebaseFirestore

struct AddChoreView: View {
    @EnvironmentObject var familyVM: FamilyViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var points = ""
    @State private var selectedChildID: String = ""
    @State private var dueDate = Date()
    
    private var isFormValid: Bool {
        !title.isEmpty &&
        !points.isEmpty &&
        Int(points) != nil &&
        !selectedChildID.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Chore Details")) {
                    TextField("Title", text: $title)
                    TextField("Points", text: $points)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Assign To")) {
                    Picker("Family Member", selection: $selectedChildID) {
                        ForEach(familyVM.members.filter { $0.role == .child }) { member in
                            Text(member.name).tag(member.id ?? "")
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                
                Section(header: Text("Due Date")) {
                    DatePicker(
                        "Due Date",
                        selection: $dueDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                }
            }
            .navigationTitle("Add New Chore")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        addChore()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    private func addChore() {
        guard let pointsValue = Int(points),
              let familyID = familyVM.family?.id else {
            return
        }
        
        let newChore = Chore(
            title: title,
            points: pointsValue,
            assignedToID: selectedChildID,
            familyID: familyID,
            dueDate: Timestamp(date: dueDate)
        )
        
        familyVM.addChore(chore: newChore)
        dismiss()
    }
}
