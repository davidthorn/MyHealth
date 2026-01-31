//
//  CaloriesSummaryView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct CaloriesSummaryView: View {
    @StateObject private var viewModel: CaloriesSummaryViewModel

    public init(service: CaloriesSummaryServiceProtocol) {
        _viewModel = StateObject(wrappedValue: CaloriesSummaryViewModel(service: service))
    }

    public var body: some View {
        Group {
            if viewModel.isAuthorized {
                if let summary = viewModel.summary {
                    List {
                        Section("Today") {
                            if let latest = summary.latest {
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
                            } else {
                                ContentUnavailableView(
                                    "No Calories Yet",
                                    systemImage: "flame",
                                    description: Text("Active calories will appear once recorded.")
                                )
                            }
                        }

                        Section("Recent Days") {
                            if summary.previous.isEmpty {
                                ContentUnavailableView(
                                    "No Previous Days",
                                    systemImage: "flame",
                                    description: Text("Daily totals will appear here.")
                                )
                            } else {
                                ForEach(summary.previous.prefix(7)) { day in
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

                        Section {
                            NavigationLink(value: CaloriesRoute.detail) {
                                Text("View All Calories")
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
        .navigationTitle("Calories")
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
        CaloriesSummaryView(service: AppServices.shared.caloriesSummaryService)
    }
}
#endif
