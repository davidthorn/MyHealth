//
//  SleepSummaryView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct SleepSummaryView: View {
    @StateObject private var viewModel: SleepSummaryViewModel

    public init(service: SleepSummaryServiceProtocol) {
        _viewModel = StateObject(wrappedValue: SleepSummaryViewModel(service: service))
    }

    private func formattedDuration(_ seconds: TimeInterval) -> String {
        let totalMinutes = Int(seconds / 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }

    public var body: some View {
        Group {
            if viewModel.isAuthorized {
                if let summary = viewModel.summary {
                    List {
                        Section("Latest") {
                            if let latest = summary.latest {
                                NavigationLink(value: SleepRoute.reading(latest.date)) {
                                    SleepLatestCardView(
                                        day: latest,
                                        formattedDuration: formattedDuration(latest.durationSeconds)
                                    )
                                }
                            } else {
                                ContentUnavailableView(
                                    "No Sleep Yet",
                                    systemImage: "bed.double",
                                    description: Text("Sleep data will appear once recorded.")
                                )
                            }
                        }

                        Section("Recent Nights") {
                            if summary.previous.isEmpty {
                                ContentUnavailableView(
                                    "No Previous Nights",
                                    systemImage: "bed.double",
                                    description: Text("Sleep history will appear here.")
                                )
                            } else {
                                ForEach(summary.previous.prefix(7)) { day in
                                    NavigationLink(value: SleepRoute.reading(day.date)) {
                                        SleepNightRowView(
                                            day: day,
                                            formattedDuration: formattedDuration(day.durationSeconds)
                                        )
                                    }
                                }
                            }
                        }

                        Section {
                            NavigationLink(value: SleepRoute.detail) {
                                Text("View All Sleep")
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                } else {
                    ContentUnavailableView(
                        "No Sleep Data",
                        systemImage: "bed.double",
                        description: Text("Sleep data will appear after it is fetched.")
                    )
                }
            } else {
                VStack(spacing: 12) {
                    ContentUnavailableView(
                        "Health Access Needed",
                        systemImage: "bed.double",
                        description: Text("Enable Health access to view sleep data.")
                    )
                    Button("Request Access") {
                        viewModel.requestAuthorization()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Sleep")
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
        SleepSummaryView(service: AppServices.shared.sleepSummaryService)
    }
}
#endif
