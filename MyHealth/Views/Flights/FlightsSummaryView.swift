//
//  FlightsSummaryView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct FlightsSummaryView: View {
    @StateObject private var viewModel: FlightsSummaryViewModel

    public init(service: FlightsSummaryServiceProtocol) {
        _viewModel = StateObject(wrappedValue: FlightsSummaryViewModel(service: service))
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
                                    Image(systemName: "figure.stairs")
                                        .font(.title2)
                                        .foregroundStyle(Color.accentColor)
                                }
                            } else {
                                ContentUnavailableView(
                                    "No Flights Yet",
                                    systemImage: "figure.stairs",
                                    description: Text("Flights climbed will appear once recorded.")
                                )
                            }
                        }

                        Section("Recent Days") {
                            if summary.previous.isEmpty {
                                ContentUnavailableView(
                                    "No Previous Days",
                                    systemImage: "figure.stairs",
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
                            NavigationLink(value: FlightsRoute.detail) {
                                Text("View All Flights")
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
        .navigationTitle("Flights")
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
        FlightsSummaryView(service: AppServices.shared.flightsSummaryService)
    }
}
#endif
