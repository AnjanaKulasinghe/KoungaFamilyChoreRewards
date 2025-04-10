//
//  AppError.swift
//  KoungaFamilyChoreRewards
//
//  Created by Anjana Kulasinghe on 10/04/2025.
//

enum AppError: Error, Identifiable {
    case auth(String)
    case firestore(String)
    case storage(String)
    case validation(String)
    
    var id: String { localizedDescription }
    var localizedDescription: String {
        switch self {
        case .auth(let msg), .firestore(let msg),
             .storage(let msg), .validation(let msg):
            return msg
        }
    }
}
