//
//  LoadingView.swift
//  KoungaFamilyChoreRewards
//
//  Created by Anjana Kulasinghe on 10/04/2025.
//

import SwiftUI

struct LoadingView: View {
    var text: String = "Loading..."
    
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            Text(text)
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground).opacity(0.9))
    }
}
