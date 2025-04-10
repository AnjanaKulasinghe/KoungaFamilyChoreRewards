//
//  ParentDashboardView.swift
//  KoungaFamilyChoreRewards
//
//  Created by Anjana Kulasinghe on 10/04/2025.
//

import SwiftUI

struct ParentDashboardView: View {
    @EnvironmentObject var familyVM: FamilyViewModel
    
    var body: some View {
        TabView {
            ChoreManagementView()
                .tabItem { Label("Chores", systemImage: "list.bullet") }
            
            RewardManagementView()
                .tabItem { Label("Rewards", systemImage: "gift") }
            
            FamilyManagementView()
                .tabItem { Label("Family", systemImage: "person.3") }
        }
        .task {
            if let familyID = familyVM.family?.id {
                familyVM.setupFamilyListeners(familyID: familyID)
            }
        }
    }
}
