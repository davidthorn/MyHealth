//
//  ActivityRingsSummaryView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct ActivityRingsSummaryView: View {
    @StateObject private var viewModel: ActivityRingsSummaryViewModel

    public init(service: ActivityRingsSummaryServiceProtocol) {
        _viewModel = StateObject(wrappedValue: ActivityRingsSummaryViewModel(service: service))
    }

    public var body: some View {
        Group {
            if viewModel.isAuthorized {
                if let summary = viewModel.summary {
                    ScrollView(.vertical) {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Today")
                                .font(.headline)

                            if let latest = summary.latest {
                                NavigationLink(value: ActivityRingsRoute.detail(latest.date)) {
                                    ActivityRingsLatestCardView(day: latest)
                                }
                                .buttonStyle(.plain)
                            } else {
                                ContentUnavailableView(
                                    "No Activity Yet",
                                    systemImage: "figure.run.circle",
                                    description: Text("Activity rings will appear after data is recorded.")
                                )
                            }

                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Recent Days")
                                        .font(.headline)
                                    Spacer()
                                    NavigationLink(value: ActivityRingsRoute.history) {
                                        Text("View All")
                                            .font(.subheadline.weight(.semibold))
                                    }
                                }

                                if summary.previous.isEmpty {
                                    ContentUnavailableView(
                                        "No Previous Days",
                                        systemImage: "figure.run.circle",
                                        description: Text("Daily activity totals will appear here.")
                                    )
                                } else {
                                    VStack(spacing: 12) {
                                        ForEach(summary.previous.prefix(5)) { day in
                                    NavigationLink(value: ActivityRingsRoute.day(day.date)) {
                                        ActivityRingsDayRowView(day: day)
                                    }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)
                    }
                    .scrollIndicators(.hidden)
                } else {
                    ContentUnavailableView(
                        "No Activity Rings",
                        systemImage: "figure.run.circle",
                        description: Text("Activity rings will appear after they are fetched.")
                    )
                }
            } else {
                VStack(spacing: 12) {
                    ContentUnavailableView(
                        "Health Access Needed",
                        systemImage: "figure.run.circle",
                        description: Text("Enable Health access to view activity rings.")
                    )
                    Button("Request Access") {
                        viewModel.requestAuthorization()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Activity Rings")
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
        ActivityRingsSummaryView(service: AppServices.shared.activityRingsSummaryService)
    }
}
#endif
