//
//  StepsDetailView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct StepsDetailView: View {
    @StateObject private var viewModel: StepsDetailViewModel

    public init(service: StepsDetailServiceProtocol) {
        _viewModel = StateObject(wrappedValue: StepsDetailViewModel(service: service))
    }

    public var body: some View {
        Group {
            if viewModel.isAuthorized {
                if let summary = viewModel.summary {
                    List {
                        if let latest = summary.latest {
                            Section("Latest Total") {
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
                            }
                        }

                        Section("Daily Totals") {
                            ForEach(summary.previous) { day in
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
        .navigationTitle("Step Details")
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
        StepsDetailView(service: AppServices.shared.stepsDetailService)
    }
}
#endif
