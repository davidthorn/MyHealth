//
//  StandHoursDetailView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct StandHoursDetailView: View {
    @StateObject private var viewModel: StandHoursDetailViewModel

    public init(service: StandHoursDetailServiceProtocol) {
        _viewModel = StateObject(wrappedValue: StandHoursDetailViewModel(service: service))
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
                                    Image(systemName: "figure.stand")
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
                        "No Stand Hours",
                        systemImage: "figure.stand",
                        description: Text("Stand hours will appear after they are fetched.")
                    )
                }
            } else {
                VStack(spacing: 12) {
                    ContentUnavailableView(
                        "Health Access Needed",
                        systemImage: "figure.stand",
                        description: Text("Enable Health access to view stand hours.")
                    )
                    Button("Request Access") {
                        viewModel.requestAuthorization()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Stand Hour Details")
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
        StandHoursDetailView(service: AppServices.shared.standHoursDetailService)
    }
}
#endif
