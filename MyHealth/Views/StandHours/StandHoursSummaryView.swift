//
//  StandHoursSummaryView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct StandHoursSummaryView: View {
    @StateObject private var viewModel: StandHoursSummaryViewModel

    public init(service: StandHoursSummaryServiceProtocol) {
        _viewModel = StateObject(wrappedValue: StandHoursSummaryViewModel(service: service))
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
                                        Text(latest.count.formatted())
                                            .font(.title2.weight(.bold))
                                        Text(latest.date.formatted(date: .abbreviated, time: .omitted))
                                            .font(.footnote)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "figure.stand")
                                        .font(.title2)
                                        .foregroundStyle(Color.accentColor)
                                }
                            } else {
                                ContentUnavailableView(
                                    "No Stand Hours Yet",
                                    systemImage: "figure.stand",
                                    description: Text("Stand hours will appear once recorded.")
                                )
                            }
                        }

                        Section("Recent Days") {
                            if summary.previous.isEmpty {
                                ContentUnavailableView(
                                    "No Previous Days",
                                    systemImage: "figure.stand",
                                    description: Text("Daily totals will appear here.")
                                )
                            } else {
                                ForEach(summary.previous.prefix(7)) { day in
                                    HStack {
                                        Text(day.date.formatted(date: .abbreviated, time: .omitted))
                                            .font(.subheadline.weight(.semibold))
                                        Spacer()
                                        Text(day.count.formatted())
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }

                        Section {
                            NavigationLink(value: StandHoursRoute.detail) {
                                Text("View All Stand Hours")
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                } else {
                    ContentUnavailableView(
                        "No Stand Hours",
                        systemImage: "figure.stand",
                        description: Text("Stand hours will appear after they are fetched.")
                    )
                }
            } else {
                VStack(spacing: 12) {
                    ContentUnavailableView(
                        "Health Access Needed",
                        systemImage: "figure.stand",
                        description: Text("Enable Health access to view stand hours.")
                    )
                    Button("Request Access") {
                        viewModel.requestAuthorization()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Stand Hours")
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
        StandHoursSummaryView(service: AppServices.shared.standHoursSummaryService)
    }
}
#endif
