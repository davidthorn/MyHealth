//
//  TodayService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

@MainActor
public final class TodayService: TodayServiceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(healthKitAdapter: HealthKitAdapterProtocol) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func updates() -> AsyncStream<TodayUpdate> {
        AsyncStream { continuation in
            let task = Task { [healthKitAdapter] in
                continuation.yield(TodayUpdate(title: "Today", latestWorkout: nil, activityRingsDay: nil))
                let activityAuthorized = await healthKitAdapter.authorizationProvider.requestActivitySummaryAuthorization()
                let workoutAuthorized = await healthKitAdapter.authorizationProvider.requestWorkoutAuthorization()
                let heartRateAuthorized = await healthKitAdapter.authorizationProvider.requestHeartRateAuthorization()
                guard !Task.isCancelled else {
                    continuation.finish()
                    return
                }

                let activitySummary = activityAuthorized
                    ? await firstValue(from: healthKitAdapter.activitySummaryStream(days: 14))
                    : nil
                let todaySummary = activityAuthorized
                    ? await healthKitAdapter.activitySummaryDay(date: Date())
                    : nil
                let activityDay = selectActivityDay(today: todaySummary, summary: activitySummary)

                let workouts = workoutAuthorized
                    ? (await firstValue(from: healthKitAdapter.workoutsStream()) ?? [])
                    : []
                let latestWorkout = workouts.first
                let latestSnapshot: TodayLatestWorkout?
                if let latestWorkout {
                    let routePoints = (try? await healthKitAdapter.workoutRoute(id: latestWorkout.id)) ?? []
                    let heartRateReadings = heartRateAuthorized
                        ? await healthKitAdapter.heartRateReadings(from: latestWorkout.startedAt, to: latestWorkout.endedAt)
                        : []
                    let heartRatePoints = WorkoutSplitCalculator.heartRateLinePoints(from: heartRateReadings)
                    latestSnapshot = TodayLatestWorkout(
                        workout: latestWorkout,
                        routePoints: routePoints,
                        heartRatePoints: heartRatePoints
                    )
                } else {
                    latestSnapshot = nil
                }

                guard !Task.isCancelled else {
                    continuation.finish()
                    return
                }
                continuation.yield(
                    TodayUpdate(
                        title: "Today",
                        latestWorkout: latestSnapshot,
                        activityRingsDay: activityDay
                    )
                )
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    private func firstValue<T>(from stream: AsyncStream<T>) async -> T? {
        for await value in stream {
            return value
        }
        return nil
    }

    private func selectActivityDay(
        today: ActivityRingsDay?,
        summary: ActivityRingsSummary?
    ) -> ActivityRingsDay? {
        if let today {
            return today
        }
        return summary?.latest ?? summary?.previous.first
    }
}
