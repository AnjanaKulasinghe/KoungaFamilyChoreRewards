//
//  AvailableRewardsView.swift
//  KoungaFamilyChoreRewards
//
//  Created by Anjana Kulasinghe on 10/04/2025.
//

import SwiftUI

struct AvailableRewardsView: View {
    @EnvironmentObject var familyVM: FamilyViewModel
    
    var availableRewards: [Reward] {
        familyVM.rewards.filter { $0.claimedByID == nil }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
                    ForEach(availableRewards) { reward in
                        RewardCard(reward: reward)
                    }
                }
                .padding()
            }
            .navigationTitle("Available Rewards")
            .overlay {
                if availableRewards.isEmpty {
                    ContentUnavailableView(
                        "No Rewards Yet",
                        systemImage: "gift",
                        description: Text("Ask your parent to add rewards!")
                    )
                }
            }
        }
    }
}

struct RewardCard: View {
    let reward: Reward
    @EnvironmentObject var familyVM: FamilyViewModel
    @State private var showClaimConfirmation = false

    
    var canAfford: Bool {
        (familyVM.currentUser?.points ?? 0) >= reward.requiredPoints
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // Reward Image
            ZStack {
                if let imageURL = reward.imageURL, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                } else {
                    Image(systemName: "gift")
                        .resizable()
                        .scaledToFit()
                        .padding(20)
                        .foregroundColor(.white)
                }
            }
            .frame(height: 120)
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Reward Info
            VStack(alignment: .leading, spacing: 4) {
                Text(reward.title)
                    .font(.headline)
                
                if !reward.description.isEmpty {
                    Text(reward.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Claim Button
                if canAfford {
                                Button("Claim (\(reward.requiredPoints) pts)") {
                                    showClaimConfirmation = true
                                }
                                .buttonStyle(.borderedProminent)
                                .confirmationDialog(
                                    "Claim Reward",
                                    isPresented: $showClaimConfirmation,
                                    actions: {
                                        Button("Confirm Claim") {
                                            claimReward()
                                        }
                                        Button("Cancel", role: .cancel) {}
                                    },
                                    message: {
                                        Text("Are you sure you want to claim \(reward.title) for \(reward.requiredPoints) points?")
                                    }
                                )
                            } else {
                                Text("Need \(reward.requiredPoints) pts")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private func claimReward() {
        guard let userID = familyVM.currentUser?.id else { return }
        familyVM.claimReward(rewardID: reward.id ?? "", byUser: userID)
    }
}
