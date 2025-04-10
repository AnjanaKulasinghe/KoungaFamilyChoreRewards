//
//  FamilyViewModel.swift
//  KoungaFamilyChoreRewards
//
//  Created by Anjana Kulasinghe on 10/04/2025.
//

import Firebase // This imports core Firebase services
import FirebaseAuth // Required for Auth
import FirebaseFirestore

class FamilyViewModel: ObservableObject {
    @Published var family: Family?
    @Published var members: [User] = []
    @Published var chores: [Chore] = []
    @Published var rewards: [Reward] = []
    @Published var isLoading = false
    @Published var error: AppError?
    @Published var currentUser: User?
    private let db = Firestore.firestore()
    
    private var listeners: [ListenerRegistration] = []
    
    func claimReward(rewardID: String, byUser userID: String) {
        let batch = db.batch()
        
        // Mark reward as claimed
        let rewardRef = db.collection("rewards").document(rewardID)
        batch.updateData([
            "claimedByID": userID,
            "claimedAt": FieldValue.serverTimestamp()
        ], forDocument: rewardRef)
        
        // Deduct points from user
        let userRef = db.collection("users").document(userID)
        batch.updateData([
            "points": FieldValue.increment(Int64(-1))
        ], forDocument: userRef)
        
        batch.commit { error in
            if let error = error {
                self.error = .firestore("Claim failed: \(error.localizedDescription)")
            }
        }
    }
    
    func setupFamilyListeners(familyID: String) {
        cleanupListeners()
        
        // Family listener
        listeners.append(db.collection("families").document(familyID)
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    self?.error = .firestore(error.localizedDescription)
                    return
                }
                self?.family = try? snapshot?.data(as: Family.self)
            })
        
        // Members listener
        listeners.append(db.collection("users")
            .whereField("familyID", isEqualTo: familyID)
            .addSnapshotListener { [weak self] snapshot, error in
                self?.members = snapshot?.documents.compactMap { try? $0.data(as: User.self) } ?? []
            })
        
        // Chores listener
        listeners.append(db.collection("chores")
            .whereField("familyID", isEqualTo: familyID)
            .addSnapshotListener { [weak self] snapshot, error in
                self?.chores = snapshot?.documents.compactMap { try? $0.data(as: Chore.self) } ?? []
            })
        
        // Rewards listener
        listeners.append(db.collection("rewards")
            .whereField("familyID", isEqualTo: familyID)
            .addSnapshotListener { [weak self] snapshot, error in
                self?.rewards = snapshot?.documents.compactMap { try? $0.data(as: Reward.self) } ?? []
            })
    }
    
    func createFamily(name: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        isLoading = true
        let family = Family(name: name, parentID: userID, memberIDs: [userID])
        do {
            let docRef = try db.collection("families").addDocument(from: family)
            db.collection("users").document(userID).updateData(["familyID": docRef.documentID])
        } catch {
            self.error = .firestore(error.localizedDescription)
        }
        isLoading = false
    }
    
    func submitChoreCompletion(choreID: String, photoURL: String) {
        db.collection("chores").document(choreID).updateData([
            "photoURL": photoURL,
            "status": "submitted",
            "submittedAt": FieldValue.serverTimestamp()
        ]) { error in
            if let error = error {
                self.error = .firestore("Failed to submit chore: \(error.localizedDescription)")
            }
        }
    }
    
    func addMember(email: String) {
            isLoading = true
            db.collection("users")
                .whereField("email", isEqualTo: email)
                .limit(to: 1)
                .getDocuments { [weak self] snapshot, error in
                    guard let self = self else { return }
                    self.isLoading = false
                    
                    if let error = error {
                        self.error = .firestore(error.localizedDescription)
                        return
                    }
                    
                    guard let document = snapshot?.documents.first,
                          let userID = document["id"] as? String,
                          let familyID = self.family?.id else {
                        self.error = .firestore("User not found")
                        return
                    }
                    
                    // Update user's familyID
                    self.db.collection("users").document(userID).updateData([
                        "familyID": familyID
                    ])
                    
                    // Add to family members
                    self.db.collection("families").document(familyID).updateData([
                        "memberIDs": FieldValue.arrayUnion([userID])
                    ])
                }
        }
    
    // Add this method
        func deleteReward(rewardID: String) {
            isLoading = true
            db.collection("rewards").document(rewardID).delete { [weak self] error in
                self?.isLoading = false
                if let error = error {
                    self?.error = .firestore("Failed to delete reward: \(error.localizedDescription)")
                }
            }
        }
    
    func addChore(chore: Chore) {
        do {
            try db.collection("chores").addDocument(from: chore)
        } catch {
            self.error = .firestore("Failed to add chore: \(error.localizedDescription)")
        }
    }
    
    private func cleanupListeners() {
        listeners.forEach { $0.remove() }
        listeners = []
    }
    
    deinit {
        cleanupListeners()
    }
}
