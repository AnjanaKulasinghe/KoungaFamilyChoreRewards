//
//  MyChoresView.swift
//  KoungaFamilyChoreRewards
//
//  Created by Anjana Kulasinghe on 10/04/2025.
//

import SwiftUI

struct MyChoresView: View {
    @EnvironmentObject private var familyVM: FamilyViewModel
    @State private var showingPhotoPicker = false
    @State private var selectedChore: Chore?
    
    private var myChores: [Chore] {
        // Proper way to access environment object's properties
        if let currentUserID = familyVM.currentUser?.id {
            return familyVM.chores.filter { $0.assignedToID == currentUserID }
        }
        return []
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(myChores) { chore in
                    ChoreCard(chore: chore) {
                        selectedChore = chore
                        showingPhotoPicker = true
                    }
                }
            }
            .navigationTitle("My Chores")
            .overlay {
                if myChores.isEmpty {
                    ContentUnavailableView(
                        "No Chores Assigned",
                        systemImage: "checkmark.circle",
                        description: Text("You don't have any chores right now!")
                    )
                }
            }
            .sheet(isPresented: $showingPhotoPicker) {
                if let chore = selectedChore {
                    PhotoSubmissionView(chore: chore)
                }
            }
        }
    }
}

struct ChoreCard: View {
    let chore: Chore
    var onSubmit: () -> Void
    @EnvironmentObject private var familyVM: FamilyViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(chore.title)
                    .font(.headline)
                Spacer()
                Text("\(chore.points) pts")
                    .font(.subheadline)
            }
            
            if let dueDate = chore.dueDate?.dateValue() {
                Text("Due: \(dueDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption)
            }
            
            HStack {
                Text(chore.status.displayText)
                    .font(.caption)
                    .padding(4)
                    .background(chore.status.backgroundColor.opacity(0.2))
                    .foregroundColor(chore.status.backgroundColor)
                    .cornerRadius(4)
                
                if chore.status == .pending || chore.status == .changesRequested {
                    Spacer()
                    Button("Submit", action: onSubmit)
                        .buttonStyle(.bordered)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
