//
//  CaloriesDetailView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct CaloriesDetailView: View {
    @StateObject private var viewModel: CaloriesDetailViewModel

    public init(service: CaloriesDetailServiceProtocol) {
        _viewModel = StateObject(wrappedValue: CaloriesDetailViewModel(service: service))
    }

    public var body: some View {
        Group {
            if viewModel.isAuthorized {
                if let summary = viewModel.summary {
                    List {
                        if let latest = summary.latest {
                            Section("Latest Total") {
                                HStack {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(Int(latest.activeKilocalories.rounded()).formatted())
                                            .font(.title2.weight(.bold))
                                        Text("Active kcal")
                                            .font(.footnote)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "flame")
                                        .font(.title2)
                                        .foregroundStyle(Color.accentColor)
                                }
                            }
                        }

                        Section("Daily Totals") {
                            ForEach(summary.previous) { day in
                                HStack {
                                    Text(day.date.formatted(date: .abbreviated, time: .omitted))
                                        .font(.subheadline.weight(.semibold))
                                    Spacer()
                                    Text(Int(day.activeKilocalories.rounded()).formatted())
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                } else {
                    ContentUnavailableView(
                        "No Calories Data",
                        systemImage: "flame",
                        description: Text("Calories data will appear after it is fetched.")
                    )
                }
            } else {
                VStack(spacing: 12) {
                    ContentUnavailableView(
                        "Health Access Needed",
                        systemImage: "flame",
                        description: Text("Enable Health access to view calories.")
                    )
                    Button("Request Access") {
                        viewModel.requestAuthorization()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Calorie Details")
        .task {
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        CaloriesDetailView(service: AppServices.shared.caloriesDetailService)
    }
}
#endif
