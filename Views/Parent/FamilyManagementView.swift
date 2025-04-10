//
//  FamilyManagementView.swift
//  KoungaFamilyChoreRewards
//
//  Created by Anjana Kulasinghe on 10/04/2025.
//

import SwiftUI

struct FamilyManagementView: View {
    @EnvironmentObject var familyVM: FamilyViewModel
    @State private var showingAddMember = false
    @State private var newMemberEmail = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("Family Members") {
                    ForEach(familyVM.members) { member in
                        MemberRow(member: member)
                    }
                }
                
                Section("Family Info") {
                    if let family = familyVM.family {
                        Text("Family Name: \(family.name)")
                        Text("Family Code: \(family.id ?? "N/A")")
                            .textSelection(.enabled)
                    }
                }
            }
            .navigationTitle("Manage Family")
            .toolbar {
                Button {
                    showingAddMember = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddMember) {
                AddMemberView(email: $newMemberEmail)
            }
        }
    }

}

struct MemberRow: View {
    let member: User
    @EnvironmentObject var familyVM: FamilyViewModel
    
    var body: some View {
        HStack {
            Text(member.name)
            Spacer()
            Text(member.roleEnum?.displayName ?? member.role) // Updated this line
                .foregroundColor(member.roleEnum == .parent ? .blue : .green)
            Text("\(member.points) pts")
                .font(.caption)
        }
    }
}
