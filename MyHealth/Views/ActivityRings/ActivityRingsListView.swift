//
//  ActivityRingsListView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct ActivityRingsListView: View {
    @StateObject private var viewModel: ActivityRingsDetailViewModel

    public init(service: ActivityRingsDetailServiceProtocol) {
        _viewModel = StateObject(wrappedValue: ActivityRingsDetailViewModel(service: service))
    }

    public var body: some View {
        Group {
            if viewModel.isAuthorized {
                if let summary = viewModel.summary {
                    List {
                        Section("Daily Totals") {
                            if let latest = summary.latest {
                                NavigationLink(value: ActivityRingsRoute.day(latest.date)) {
                                    ActivityRingsDayRowView(day: latest)
                                }
                            }
                            ForEach(summary.previous) { day in
                                NavigationLink(value: ActivityRingsRoute.day(day.date)) {
                                    ActivityRingsDayRowView(day: day)
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
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
        ActivityRingsListView(service: AppServices.shared.activityRingsDetailService)
    }
}
#endif
