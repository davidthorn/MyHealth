//
//  RestingHeartRateHistoryView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct RestingHeartRateHistoryView: View {
    @StateObject private var viewModel: RestingHeartRateHistoryViewModel

    public init(service: RestingHeartRateHistoryServiceProtocol) {
        _viewModel = StateObject(wrappedValue: RestingHeartRateHistoryViewModel(service: service))
    }

    public var body: some View {
        Group {
            if viewModel.isAuthorized {
                if let summary = viewModel.summary {
                    List {
                        Section("Daily Resting HR") {
                            if let latest = summary.latest {
                                NavigationLink(value: RestingHeartRateRoute.day(latest.date)) {
                                    HStack {
                                        Text(latest.date.formatted(date: .abbreviated, time: .omitted))
                                            .font(.subheadline.weight(.semibold))
                                        Spacer()
                                        Text("\(Int(latest.averageBpm.rounded())) bpm")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            ForEach(summary.previous) { day in
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
        .navigationTitle("Resting HR History")
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
        RestingHeartRateHistoryView(service: AppServices.shared.restingHeartRateHistoryService)
    }
}
#endif
