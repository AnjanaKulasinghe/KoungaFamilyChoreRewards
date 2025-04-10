//
//  UserRole.swift
//  KoungaFamilyChoreRewards
//
//  Created by Anjana Kulasinghe on 10/04/2025.
//

enum UserRole: String, Codable, CaseIterable, Identifiable {
    case parent = "parent"
    case child = "child"
    
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .parent: return "Parent"
        case .child: return "Child"
        }
    }
}
