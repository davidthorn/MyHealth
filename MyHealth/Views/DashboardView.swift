//
//  DashboardView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel
    private let onActivityRingsTap: (ActivityRingsDay) -> Void
    private let onActivityRingMetricTap: (ActivityRingsMetric, ActivityRingsDay) -> Void

    public init(
        service: DashboardServiceProtocol,
        onActivityRingsTap: @escaping (ActivityRingsDay) -> Void,
        onActivityRingMetricTap: @escaping (ActivityRingsMetric, ActivityRingsDay) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: DashboardViewModel(service: service))
        self.onActivityRingsTap = onActivityRingsTap
        self.onActivityRingMetricTap = onActivityRingMetricTap
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.title)
                        .font(.title)
                    Text("Overview of your day")
                        .foregroundStyle(.secondary)
                }

                if let activityDay = viewModel.activityRingsDay {
                    ActivityRingsLatestCardView(day: activityDay)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            onActivityRingsTap(activityDay)
                        }
                } else {
                    ContentUnavailableView(
                        "No Activity Rings",
                        systemImage: "target",
                        description: Text("Activity rings will appear once recorded.")
                    )
                }

                if let latestWorkout = viewModel.latestWorkout {
                    DashboardLatestWorkoutCardView(snapshot: latestWorkout)
                } else {
                    ContentUnavailableView(
                        "No Recent Workout",
                        systemImage: "figure.run",
                        description: Text("Recent workouts will appear here once recorded.")
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
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
    DashboardView(
        service: AppServices.shared.dashboardService,
        onActivityRingsTap: { _ in },
        onActivityRingMetricTap: { _, _ in }
    )
}
#endif
