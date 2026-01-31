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
                    List {
                        if let latest = summary.latest {
                            Section("Latest") {
                                SleepLatestCardView(
                                    day: latest,
                                    formattedDuration: formattedDuration(latest.durationSeconds)
                                )
                            }
                        }

                        Section("Nightly Totals") {
                            ForEach(summary.previous) { day in
                                NavigationLink(value: SleepRoute.reading(day.date)) {
                                    SleepNightRowView(
                                        day: day,
                                        formattedDuration: formattedDuration(day.durationSeconds)
                                    )
                                }
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
