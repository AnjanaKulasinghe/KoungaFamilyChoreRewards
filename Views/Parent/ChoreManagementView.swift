//
//  ChoreManagementView.swift
//  KoungaFamilyChoreRewards
//
//  Created by Anjana Kulasinghe on 10/04/2025.
//

import SwiftUI

struct ChoreManagementView: View {
    @EnvironmentObject private var familyVM: FamilyViewModel
    @State private var showingAddChore = false
    @State private var choreToDelete: Chore?
    @State private var showDeleteAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(familyVM.chores) { chore in
                    ChoreRow(chore: chore)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                choreToDelete = chore
                                showDeleteAlert = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .navigationTitle("Manage Chores")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddChore = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddChore) {
                AddChoreView()
            }
            .alert("Delete Chore",
                   isPresented: $showDeleteAlert,
                   presenting: choreToDelete) { chore in
                Button("Delete", role: .destructive) {
                    familyVM.deleteChore(choreID: chore.id ?? "")
                }
                Button("Cancel", role: .cancel) {}
            } message: { chore in
                Text("Are you sure you want to delete '\(chore.title)'?")
            }
        }
    }
}

struct ChoreRow: View {
    let chore: Chore
    @EnvironmentObject private var familyVM: FamilyViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(chore.title)
                    .font(.headline)
                Spacer()
                Text("\(chore.points) pts")
                    .foregroundColor(.secondary)
            }
            
            if let child = familyVM.members.first(where: { $0.id == chore.assignedToID }) {
                Text("Assigned to: \(child.name)")
                    .font(.caption)
            }
            
            HStack {
                Text(chore.status.rawValue.capitalized)
                    .font(.caption)
                    .padding(4)
                    .background(statusColor.opacity(0.2))
                    .foregroundColor(statusColor)
                    .cornerRadius(4)
                
                if let dueDate = chore.dueDate?.dateValue() {
                    Spacer()
                    Text("Due: \(dueDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption2)
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private var statusColor: Color {
        switch chore.status {
        case .pending: return .orange
        case .submitted: return .blue
        case .approved: return .green
        case .rejected: return .red
        case .changesRequested: return .purple
        }
    }
}
