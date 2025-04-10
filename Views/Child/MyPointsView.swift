//
//  MyPointsView.swift
//  KoungaFamilyChoreRewards
//
//  Created by Anjana Kulasinghe on 10/04/2025.
//

import SwiftUI
import Charts

struct MyPointsView: View {
    @EnvironmentObject var familyVM: FamilyViewModel
    
    // Sample data - replace with your actual point history
    let pointHistory: [PointEntry] = [
        PointEntry(date: Date().addingTimeInterval(-86400 * 6), points: 20, reason: "Cleaned room"),
        PointEntry(date: Date().addingTimeInterval(-86400 * 5), points: 15, reason: "Homework done"),
        PointEntry(date: Date().addingTimeInterval(-86400 * 3), points: -30, reason: "Bought toy"),
        PointEntry(date: Date().addingTimeInterval(-86400 * 1), points: 25, reason: "Helped with dishes")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Points Summary
                VStack {
                    Text("Your Points")
                        .font(.title2.bold())
                    Text("\(familyVM.currentUser?.points ?? 0)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.accentColor)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Points Chart
                VStack(alignment: .leading) {
                    Text("Points History")
                        .font(.headline)
                    Chart(pointHistory) { entry in
                        BarMark(
                            x: .value("Day", entry.date, unit: .day),
                            y: .value("Points", entry.points)
                        )
                        .foregroundStyle(entry.points > 0 ? Color.green : Color.red)
                    }
                    .frame(height: 150)
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day)) { value in
                            AxisGridLine()
                            AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                        }
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Recent Transactions
                VStack(alignment: .leading) {
                    Text("Recent Activity")
                        .font(.headline)
                    
                    ForEach(pointHistory.prefix(3)) { entry in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(entry.reason)
                                Text(entry.date.formatted(date: .omitted, time: .shortened))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text("\(entry.points > 0 ? "+" : "")\(entry.points)")
                                .foregroundColor(entry.points > 0 ? .green : .red)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("My Points")
    }
}

struct PointEntry: Identifiable {
    let id = UUID()
    let date: Date
    let points: Int
    let reason: String
}
