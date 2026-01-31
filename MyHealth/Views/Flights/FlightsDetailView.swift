//
//  FlightsDetailView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct FlightsDetailView: View {
    @StateObject private var viewModel: FlightsDetailViewModel

    public init(service: FlightsDetailServiceProtocol) {
        _viewModel = StateObject(wrappedValue: FlightsDetailViewModel(service: service))
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
                                    Image(systemName: "figure.stairs")
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
                        "No Flights Data",
                        systemImage: "figure.stairs",
                        description: Text("Flights data will appear after it is fetched.")
                    )
                }
            } else {
                VStack(spacing: 12) {
                    ContentUnavailableView(
                        "Health Access Needed",
                        systemImage: "figure.stairs",
                        description: Text("Enable Health access to view flights data.")
                    )
                    Button("Request Access") {
                        viewModel.requestAuthorization()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Flight Details")
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
        FlightsDetailView(service: AppServices.shared.flightsDetailService)
    }
}
#endif
