//
//  RestingHeartRateSummaryView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct RestingHeartRateSummaryView: View {
    @StateObject private var viewModel: RestingHeartRateSummaryViewModel

    public init(service: RestingHeartRateSummaryServiceProtocol) {
        _viewModel = StateObject(wrappedValue: RestingHeartRateSummaryViewModel(service: service))
    }

    public var body: some View {
        Group {
            if viewModel.isAuthorized {
                if let summary = viewModel.summary {
                    List {
                        if !viewModel.statItems.isEmpty {
                            Section("Summary") {
                                ForEach(viewModel.statItems, id: \.title) { item in
                                    LabeledContent(item.title, value: item.value)
                                }
                            }
                        }
                        Section("Latest") {
                            if let latest = summary.latest {
                                VStack(spacing: 12) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text("\(Int(latest.averageBpm.rounded())) bpm")
                                                .font(.title2.weight(.bold))
                                            Text(latest.date.formatted(date: .abbreviated, time: .omitted))
                                                .font(.footnote)
                                                .foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                        Image(systemName: "heart")
                                            .font(.title2)
                                            .foregroundStyle(Color.accentColor)
                                    }
                                    RestingHeartRateRangeChartView(
                                        points: viewModel.latestChartPoints(),
                                        xAxisFormat: .dateTime.month().day(),
                                        desiredXAxisCount: 5
                                    )
                                }
                            } else {
                                ContentUnavailableView(
                                    "No Resting Heart Rate",
                                    systemImage: "heart",
                                    description: Text("Resting heart rate will appear once recorded.")
                                )
                            }
                        }

                        Section("Recent Days") {
                            if summary.previous.isEmpty {
                                ContentUnavailableView(
                                    "No Previous Days",
                                    systemImage: "heart",
                                    description: Text("Daily resting heart rate values will appear here.")
                                )
                            } else {
                                ForEach(summary.previous.prefix(7)) { day in
                                    NavigationLink(value: RestingHeartRateRoute.day(day.date)) {
                                        HStack {
                                            Text(day.date.formatted(date: .abbreviated, time: .omitted))
                                                .font(.subheadline.weight(.semibold))
                                            Spacer()
                                            Text("\(Int(day.averageBpm.rounded())) bpm")
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                }
                            }
                        }

                        Section {
                            NavigationLink(value: RestingHeartRateRoute.history) {
                                Text("View History")
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                } else {
                    ContentUnavailableView(
                        "No Resting Heart Rate",
                        systemImage: "heart",
                        description: Text("Resting heart rate will appear after it is fetched.")
                    )
                }
            } else {
                VStack(spacing: 12) {
                    ContentUnavailableView(
                        "Health Access Needed",
                        systemImage: "heart",
                        description: Text("Enable Health access to view resting heart rate.")
                    )
                    Button("Request Access") {
                        viewModel.requestAuthorization()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Resting Heart Rate")
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
        RestingHeartRateSummaryView(service: AppServices.shared.restingHeartRateSummaryService)
    }
}
#endif
