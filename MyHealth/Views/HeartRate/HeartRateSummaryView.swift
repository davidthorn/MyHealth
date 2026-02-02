//
//  HeartRateSummaryView.swift
//  MyHealth
//
//  Created by Codex.
//

import SwiftUI
import Models

public struct HeartRateSummaryView: View {
    @StateObject private var viewModel: HeartRateSummaryViewModel

    public init(service: HeartRateSummaryServiceProtocol) {
        _viewModel = StateObject(wrappedValue: HeartRateSummaryViewModel(service: service))
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
                                LabeledContent("Heart Rate", value: "\(Int(latest.bpm.rounded())) bpm")
                                LabeledContent(
                                    "Time",
                                    value: latest.date.formatted(date: .abbreviated, time: .shortened)
                                )
                            } else {
                                ContentUnavailableView(
                                    "No Recent Reading",
                                    systemImage: "heart.text.square",
                                    description: Text("Capture a heart rate sample to see it here.")
                                )
                            }
                        }

                        Section("Previous Readings") {
                            if summary.previous.isEmpty {
                                ContentUnavailableView(
                                    "No Previous Readings",
                                    systemImage: "heart.text.square",
                                    description: Text("Historic heart rate samples will appear here.")
                                )
                            } else {
                                ForEach(summary.previous) { reading in
                                    NavigationLink(value: HeartRateRoute.reading(reading.id)) {
                                        HStack {
                                            Text("\(Int(reading.bpm.rounded())) bpm")
                                                .font(.subheadline.weight(.semibold))
                                            Spacer()
                                            Text(reading.date.formatted(date: .abbreviated, time: .shortened))
                                                .font(.footnote)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                } else {
                    ContentUnavailableView(
                        "No Heart Rate Data",
                        systemImage: "heart.text.square",
                        description: Text("Heart rate data will appear after it is fetched.")
                    )
                }
            } else {
                VStack(spacing: 12) {
                    ContentUnavailableView(
                        "Health Access Needed",
                        systemImage: "heart.text.square",
                        description: Text("Enable Health access to view heart rate data.")
                    )
                    Button("Request Access") {
                        viewModel.requestAuthorization()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Heart Rate")
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
        HeartRateSummaryView(service: AppServices.shared.heartRateSummaryService)
    }
}
#endif
