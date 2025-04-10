//
//  SignUpView.swift
//  KoungaFamilyChoreRewards
//
//  Created by Anjana Kulasinghe on 10/04/2025.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var role: UserRole = .child
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Full Name", text: $name)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.words)
            
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textContentType(.emailAddress)
            
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
                .textContentType(.newPassword)
            
            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(.roundedBorder)
                .textContentType(.newPassword)
            
            // Fixed Picker implementation
            Picker("Role", selection: $role) {
                ForEach(UserRole.allCases) { role in
                    Text(role.displayName)
                        .tag(role)
                }
            }
            .pickerStyle(.segmented)
            
            Button(action: {
                            Task {
                                await signUp()
                            }
                        }) {
                            if authVM.isLoading {
                                ProgressView()
                            } else {
                                Text("Create Account")
                            }
                        }
            .buttonStyle(.borderedProminent)
            .disabled(!formIsValid || authVM.isLoading)
        }
        .padding()
    }
    
    private var formIsValid: Bool {
            !name.isEmpty &&
            !email.isEmpty &&
            email.contains("@") &&
            !password.isEmpty &&
            password == confirmPassword &&
            password.count >= 6
        }
        
        private func signUp() async {
            await authVM.signUp(
                name: name,
                email: email,
                password: password,
                role: role
            )
        }
}
