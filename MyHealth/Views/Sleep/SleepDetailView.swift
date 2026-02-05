//
//  SleepDetailView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct SleepDetailView: View {
    @StateObject private var viewModel: SleepDetailViewModel

    public init(service: SleepDetailServiceProtocol) {
        _viewModel = StateObject(wrappedValue: SleepDetailViewModel(service: service))
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
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Sleep History")
                                    .font(.title3.weight(.semibold))
                                Text("Review nightly totals and recent sleep.")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }

                            VStack(alignment: .leading, spacing: 12) {
                                Text("Latest")
                                    .font(.headline)
                                if let latest = summary.latest {
                                    NavigationLink(value: SleepRoute.reading(latest.date)) {
                                        SleepLatestCardView(
                                            day: latest,
                                            formattedDuration: formattedDuration(latest.durationSeconds)
                                        )
                                    }
                                    .buttonStyle(.plain)
                                } else {
                                    ContentUnavailableView(
                                        "No Sleep Yet",
                                        systemImage: "bed.double",
                                        description: Text("Sleep data will appear once recorded.")
                                    )
                                }
                            }

                            VStack(alignment: .leading, spacing: 12) {
                                Text("Nightly Totals")
                                    .font(.headline)
                                Text("All recorded nights, newest first.")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                let nights = summary.previous.filter { $0.durationSeconds > 0 }
                                if nights.isEmpty {
                                    ContentUnavailableView(
                                        "No Tracked Sleep",
                                        systemImage: "bed.double",
                                        description: Text("Wear your watch or track sleep to see nightly totals.")
                                    )
                                } else {
                                    LazyVStack(spacing: 10) {
                                        ForEach(nights) { day in
                                            NavigationLink(value: SleepRoute.reading(day.date)) {
                                                SleepRecentNightCardView(
                                                    day: day,
                                                    formattedDuration: formattedDuration(day.durationSeconds)
                                                )
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)
                    }
                    .scrollIndicators(.hidden)
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
        .navigationTitle("Sleep Details")
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
        SleepDetailView(service: AppServices.shared.sleepDetailService)
    }
}
#endif
