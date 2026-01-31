//
//  DashboardService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

@MainActor
public final class DashboardService: DashboardServiceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(healthKitAdapter: HealthKitAdapterProtocol) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func updates() -> AsyncStream<DashboardUpdate> {
        AsyncStream { continuation in
            let task = Task { [healthKitAdapter] in
                continuation.yield(DashboardUpdate(title: "Dashboard", latestWorkout: nil, activityRingsDay: nil))
                let isAuthorized = await healthKitAdapter.requestAuthorization()
                guard isAuthorized, !Task.isCancelled else {
                    continuation.finish()
                    return
                }
                let activitySummary = await firstValue(from: healthKitAdapter.activitySummaryStream(days: 1))
                let activityDay = activitySummary?.latest

                let workouts = await firstValue(from: healthKitAdapter.workoutsStream()) ?? []
                let latestWorkout = workouts.first
                let latestSnapshot: DashboardLatestWorkout?
                if let latestWorkout {
                    let routePoints = (try? await healthKitAdapter.workoutRoute(id: latestWorkout.id)) ?? []
                    let heartRateReadings = await healthKitAdapter.heartRateReadings(
                        from: latestWorkout.startedAt,
                        to: latestWorkout.endedAt
                    )
                    let heartRatePoints = WorkoutSplitCalculator.heartRateLinePoints(from: heartRateReadings)
                    latestSnapshot = DashboardLatestWorkout(
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
                    DashboardUpdate(
                        title: "Dashboard",
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
}
