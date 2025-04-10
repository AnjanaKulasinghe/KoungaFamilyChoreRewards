//
//  ChildDashboardView.swift
//  KoungaFamilyChoreRewards
//
//  Created by Anjana Kulasinghe on 10/04/2025.
//
import SwiftUI

struct ChildDashboardView: View {
    var body: some View {
        TabView {
            MyChoresView()
                .tabItem { Label("My Chores", systemImage: "checklist") }
            
            AvailableRewardsView()
                .tabItem { Label("Rewards", systemImage: "gift") }
            
            MyPointsView()
                .tabItem { Label("Points", systemImage: "star.fill") }
        }
    }
}
