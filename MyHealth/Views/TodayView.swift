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

                if let sleepDay = viewModel.sleepDay {
                    NavigationLink(value: TodayRoute.sleepSummary) {
                        TodaySleepCardView(day: sleepDay, formattedDuration: viewModel.sleepDurationText)
                    }
                    .buttonStyle(.plain)
                } else {
                    NavigationLink(value: TodayRoute.sleepSummary) {
                        ContentUnavailableView(
                            "No Sleep Data",
                            systemImage: "bed.double.fill",
                            description: Text("Sleep data will appear once recorded.")
                        )
                    }
                    .buttonStyle(.plain)
                }

                if let restingDay = viewModel.restingHeartRateLatest {
                    TodayRecoveryCardView(
                        restingDay: restingDay,
                        restingChartPoints: viewModel.restingHeartRateChartPoints,
                        hrvReading: viewModel.heartRateVariabilityLatest
                    )
                } else {
                    ContentUnavailableView(
                        "No Recovery Data",
                        systemImage: "heart.fill",
                        description: Text("Resting HR and HRV will appear once recorded.")
                    )
                }

                TodayVitalsCardView(latestHeartRate: viewModel.latestHeartRateText)

                NavigationLink(value: TodayRoute.hydrationOverview) {
                    TodayHydrationCardView(hydrationText: viewModel.hydrationText)
                }
                .buttonStyle(.plain)

                TodayActivityStatsCardView(
                    steps: viewModel.stepsText,
                    activeEnergy: viewModel.caloriesText,
                    exerciseMinutes: viewModel.exerciseMinutesText,
                    standHours: viewModel.standHoursText
                )

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
