//
//  AuthView.swift
//  KoungaFamilyChoreRewards
//
//  Created by Anjana Kulasinghe on 10/04/2025.
//

import SwiftUI

struct AuthView: View {
    @State private var isLoginMode = true
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Picker("Mode", selection: $isLoginMode) {
                        Text("Login").tag(true)
                        Text("Sign Up").tag(false)
                    }
                    .pickerStyle(.segmented)
                    
                    if isLoginMode {
                        LoginView()
                    } else {
                        SignUpView()
                    }
                }
                .padding()
            }
            .navigationTitle(isLoginMode ? "Login" : "Sign Up")
            .background(Color(.systemGroupedBackground))
        }
    }
}
