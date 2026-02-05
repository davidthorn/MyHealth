//
//  TodayView.swift
//  MyHealth
//
//  Created by Codex.
//

import Models
import SwiftUI

public struct TodayView: View {
    @StateObject private var viewModel: TodayViewModel

    public init(service: TodayServiceProtocol) {
        _viewModel = StateObject(wrappedValue: TodayViewModel(service: service))
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Today at a glance")
                        .foregroundStyle(.secondary)
                }

                if let activityDay = viewModel.activityRingsDay {
                    NavigationLink(value: TodayRoute.activityRingsDay(activityDay.date)) {
                        ActivityRingsLatestCardView(day: activityDay)
                    }
                    .buttonStyle(.plain)
                } else {
                    NavigationLink(value: TodayRoute.activityRingsSummary) {
                        ContentUnavailableView(
                            "No Activity Rings",
                            systemImage: "target",
                            description: Text("Activity rings will appear once recorded.")
                        )
                    }
                    .buttonStyle(.plain)
                }

                if let latestWorkout = viewModel.latestWorkout {
                    TodayLatestWorkoutCardView(snapshot: latestWorkout)
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
    TodayView(service: AppServices.shared.todayService)
}
#endif
