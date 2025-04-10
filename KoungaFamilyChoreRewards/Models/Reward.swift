//
//  Reward.swift
//  KoungaFamilyChoreRewards
//
//  Created by Anjana Kulasinghe on 10/04/2025.
//

import FirebaseFirestore

struct Reward: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var imageURL: String?
    var requiredPoints: Int
    var familyID: String
    var claimedByID: String?
    @ServerTimestamp var createdAt: Timestamp?
}
