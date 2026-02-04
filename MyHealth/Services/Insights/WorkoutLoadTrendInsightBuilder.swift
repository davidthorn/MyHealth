//
//  WorkoutLoadTrendInsightBuilder.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

public struct WorkoutLoadTrendInsightBuilder {
    private let healthKitAdapter: HealthKitAdapterProtocol
    private let workouts: [Workout]
    private let includeHeartRate: Bool

    public init(
        healthKitAdapter: HealthKitAdapterProtocol,
        workouts: [Workout],
        includeHeartRate: Bool
    ) {
        self.healthKitAdapter = healthKitAdapter
        self.workouts = workouts
        self.includeHeartRate = includeHeartRate
    }

    public func build() async -> WorkoutLoadTrendInsight? {
        let calendar = Calendar.current
        let windowEnd = Date()
        guard let currentWeek = calendar.dateInterval(of: .weekOfYear, for: windowEnd) else { return nil }
        guard let previousWeekStart = calendar.date(byAdding: .weekOfYear, value: -1, to: currentWeek.start) else {
            return nil
        }
        let previousWeek = DateInterval(start: previousWeekStart, end: currentWeek.start)

        let currentWorkouts = workouts.filter { currentWeek.contains($0.startedAt) }
        let previousWorkouts = workouts.filter { previousWeek.contains($0.startedAt) }

        guard !currentWorkouts.isEmpty || !previousWorkouts.isEmpty else { return nil }

        let currentMinutes = totalMinutes(for: currentWorkouts)
        let previousMinutes = totalMinutes(for: previousWorkouts)
        let currentLoad = await loadScore(for: currentWorkouts)
        let previousLoad = await loadScore(for: previousWorkouts)
        let delta = (currentLoad != nil && previousLoad != nil) ? (currentLoad! - previousLoad!) : nil

        let status = determineStatus(
            currentLoad: currentLoad,
            previousLoad: previousLoad,
            delta: delta
        )

        return WorkoutLoadTrendInsight(
            windowStart: previousWeek.start,
            windowEnd: windowEnd,
            currentWeekStart: currentWeek.start,
            currentWeekEnd: currentWeek.end,
            previousWeekStart: previousWeek.start,
            previousWeekEnd: previousWeek.end,
            currentLoad: currentLoad,
            previousLoad: previousLoad,
            delta: delta,
            status: status,
            currentWorkoutCount: currentWorkouts.count,
            previousWorkoutCount: previousWorkouts.count,
            currentMinutes: currentMinutes,
            previousMinutes: previousMinutes
        )
    }

    private func totalMinutes(for workouts: [Workout]) -> Double {
        workouts.map { workout in
            workout.durationSeconds ?? workout.endedAt.timeIntervalSince(workout.startedAt)
        }
        .map { max(0, $0 / 60) }
        .reduce(0, +)
    }

    private func loadScore(for workouts: [Workout]) async -> Double? {
        var scores: [Double] = []
        scores.reserveCapacity(workouts.count)

        for workout in workouts {
            guard !Task.isCancelled else { return nil }
            let durationMinutes = max(0, (workout.durationSeconds ?? workout.endedAt.timeIntervalSince(workout.startedAt)) / 60)
            var intensityFactor: Double = 1.0

            if includeHeartRate {
                let readings = await healthKitAdapter.heartRateReadings(from: workout.startedAt, to: workout.endedAt)
                if let average = WorkoutRouteMetrics.averageHeartRate(readings: readings) {
                    intensityFactor = max(0.5, average / 100)
                }
            }

            scores.append(durationMinutes * intensityFactor)
        }

        guard !scores.isEmpty else { return nil }
        return scores.reduce(0, +)
    }

    private func determineStatus(
        currentLoad: Double?,
        previousLoad: Double?,
        delta: Double?
    ) -> WorkoutLoadTrendStatus {
        guard let previousLoad, let delta else { return .unclear }
        _ = currentLoad
        let threshold = max(10, previousLoad * 0.1)
        if delta > threshold {
            return .rampingUp
        }
        if delta < -threshold {
            return .tapering
        }
        return .steady
    }
}
