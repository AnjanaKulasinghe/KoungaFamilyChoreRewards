//
//  FirestoreManager.swift
//  KoungaFamilyChoreRewards
//
//  Created by Anjana Kulasinghe on 10/04/2025.
//

import FirebaseFirestore

class FirestoreManager {
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func getUser(byID id: String) async throws -> User? {
        let doc = try await db.collection("users").document(id).getDocument()
        return try doc.data(as: User.self)
    }
    
    func updateUserPoints(userID: String, newPoints: Int) async throws {
        try await db.collection("users").document(userID).updateData([
            "points": newPoints
        ])
    }
}
