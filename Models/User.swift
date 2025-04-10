//
//  User.swift
//  KoungaFamilyChoreRewards
//
//  Created by Anjana Kulasinghe on 10/04/2025.
//

import FirebaseFirestore

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var role: String  // Change this to String to match Firebase storage
    var points: Int = 0
    var familyID: String?
    var photoURL: String?
    
    // Helper computed property
    var roleEnum: UserRole? {
        return UserRole(rawValue: role)
    }
}
