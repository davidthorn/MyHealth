//
//  StepsSummaryView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct StepsSummaryView: View {
    @StateObject private var viewModel: StepsSummaryViewModel

    public init(service: StepsSummaryServiceProtocol) {
        _viewModel = StateObject(wrappedValue: StepsSummaryViewModel(service: service))
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
                                    Image(systemName: "figure.walk")
                                        .font(.title2)
                                        .foregroundStyle(Color.accentColor)
                                }
                            } else {
                                ContentUnavailableView(
                                    "No Steps Yet",
                                    systemImage: "figure.walk",
                                    description: Text("Step data will appear once it is recorded.")
                                )
                            }
                        }

                        Section("Recent Days") {
                            if summary.previous.isEmpty {
                                ContentUnavailableView(
                                    "No Previous Days",
                                    systemImage: "figure.walk",
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
                            NavigationLink(value: StepsRoute.detail) {
                                Text("View All Steps")
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                } else {
                    ContentUnavailableView(
                        "No Step Data",
                        systemImage: "figure.walk",
                        description: Text("Step data will appear after it is fetched.")
                    )
                }
            } else {
                VStack(spacing: 12) {
                    ContentUnavailableView(
                        "Health Access Needed",
                        systemImage: "figure.walk",
                        description: Text("Enable Health access to view step data.")
                    )
                    Button("Request Access") {
                        viewModel.requestAuthorization()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Steps")
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
        StepsSummaryView(service: AppServices.shared.stepsSummaryService)
    }
}
#endif
