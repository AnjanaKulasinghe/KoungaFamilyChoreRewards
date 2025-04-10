//
//  Chore.swift
//  KoungaFamilyChoreRewards
//
//  Created by Anjana Kulasinghe on 10/04/2025.
//

import SwiftUI  // Add this import
import FirebaseFirestore

enum ChoreStatus: String, Codable {
    case pending = "pending"
    case submitted = "submitted"
    case approved = "approved"
    case rejected = "rejected"
    case changesRequested = "changes_requested"
    
    var displayText: String {
        switch self {
        case .pending: return "Pending"
        case .submitted: return "Submitted"
        case .approved: return "Approved"
        case .rejected: return "Rejected"
        case .changesRequested: return "Changes Needed"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .pending: return .orange
        case .submitted: return .blue
        case .approved: return .green
        case .rejected: return .red
        case .changesRequested: return .purple
        }
    }
}

struct Chore: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var points: Int
    var assignedToID: String
    var familyID: String
    var status: ChoreStatus = .pending
    var photoURL: String?
    @ServerTimestamp var createdAt: Timestamp?
    var dueDate: Timestamp?
}
