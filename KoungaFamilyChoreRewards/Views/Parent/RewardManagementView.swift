//
//  RewardManagementView.swift
//  KoungaFamilyChoreRewards
//
//  Created by Anjana Kulasinghe on 10/04/2025.
//

import SwiftUI
import FirebaseFirestore

struct RewardManagementView: View {
    @EnvironmentObject var familyVM: FamilyViewModel
    @State private var showingAddReward = false
    @State private var showingDeleteAlert = false
    @State private var rewardToDelete: Reward?
    
    var body: some View {
        NavigationStack {
            Group {
                if familyVM.rewards.isEmpty {
                    ContentUnavailableView(
                        "No Rewards Yet",
                        systemImage: "gift",
                        description: Text("Add rewards to motivate your family!")
                    )
                } else {
                    List {
                        ForEach(familyVM.rewards) { reward in
                            RewardRow(reward: reward)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        rewardToDelete = reward
                                        showingDeleteAlert = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                }
            }
            .navigationTitle("Manage Rewards")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddReward = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddReward) {
                AddRewardView()
            }
            .alert("Delete Reward?", isPresented: $showingDeleteAlert, presenting: rewardToDelete) { reward in
                Button("Delete", role: .destructive) {
                    familyVM.deleteReward(rewardID: reward.id ?? "")
                }
                Button("Cancel", role: .cancel) {}
            } message: { reward in
                Text("Are you sure you want to delete \(reward.title)? This cannot be undone.")
            }
        }
    }
}

struct RewardRow: View {
    let reward: Reward
    @EnvironmentObject var familyVM: FamilyViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            rewardImage
            
            VStack(alignment: .leading, spacing: 4) {
                Text(reward.title)
                    .font(.headline)
                
                if !reward.description.isEmpty {
                    Text(reward.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let claimedByID = reward.claimedByID,
                   let member = familyVM.members.first(where: { $0.id == claimedByID }) {
                    Text("Claimed by: \(member.name)")
                        .font(.caption)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(reward.requiredPoints) pts")
                    .font(.subheadline)
                    .foregroundColor(reward.claimedByID == nil ? .blue : .gray)
            }
        }
        .padding(.vertical, 8)
        .opacity(reward.claimedByID != nil ? 0.6 : 1.0)
    }
    
    @ViewBuilder
    private var rewardImage: some View {
        if let imageURL = reward.imageURL, let url = URL(string: imageURL) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                case .failure:
                    Image(systemName: "gift")
                        .frame(width: 50, height: 50)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                case .empty:
                    ProgressView()
                        .frame(width: 50, height: 50)
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            Image(systemName: "gift")
                .frame(width: 50, height: 50)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}
