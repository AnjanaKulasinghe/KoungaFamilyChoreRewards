//
//  Family.swift
//  KoungaFamilyChoreRewards
//
//  Created by Anjana Kulasinghe on 10/04/2025.
//

import FirebaseFirestore

struct Family: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var parentID: String
    var memberIDs: [String]
    @ServerTimestamp var createdAt: Timestamp?
}
