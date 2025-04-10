//
//  AuthViewModel.swift
//  KoungaFamilyChoreRewards
//
//  Created by Anjana Kulasinghe on 10/04/2025.
//

import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var error: AppError?
    
    init() {
        userSession = Auth.auth().currentUser
        Task { await fetchUser() }
    }
    
    @MainActor
    func signIn(email: String, password: String) async {
        isLoading = true
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            userSession = result.user
            await fetchUser()
        } catch {
            self.error = .auth(error.localizedDescription)
        }
        isLoading = false
    }
    
    @MainActor
    func signUp(name: String, email: String, password: String, role: UserRole) async {
        isLoading = true
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            // Convert UserRole to String for storage
            let user = User(
                id: result.user.uid,
                name: name,
                email: email,
                role: role.rawValue,  // Store the raw string value
                points: 0
            )
            
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id!).setData(encodedUser)
            
            userSession = result.user
            currentUser = user
        } catch {
            self.error = .auth(error.localizedDescription)
        }
        isLoading = false
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            userSession = nil
            currentUser = nil
        } catch {
            self.error = .auth(error.localizedDescription)
        }
    }
    
    @MainActor
    func fetchUser() async {
        guard let uid = userSession?.uid else { return }
        do {
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
            currentUser = try snapshot.data(as: User.self)
        } catch {
            self.error = .firestore(error.localizedDescription)
        }
    }
}
