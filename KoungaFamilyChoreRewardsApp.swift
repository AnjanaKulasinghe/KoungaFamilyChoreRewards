//
//  KoungaFamilyChoreRewardsApp.swift
//  KoungaFamilyChoreRewards
//
//  Created by Anjana Kulasinghe on 10/04/2025.
//

import SwiftUI
import FirebaseCore

@main
struct KoungaFamilyChoreRewardsApp: App {
    @StateObject var authVM = AuthViewModel()
    @StateObject var familyVM = FamilyViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authVM)
                .environmentObject(familyVM)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        Group {
            if authVM.userSession == nil {
                AuthView()
            } else if authVM.currentUser?.roleEnum == .parent {
                ParentDashboardView()
            } else {
                ChildDashboardView()
            }
        }
    }
}
