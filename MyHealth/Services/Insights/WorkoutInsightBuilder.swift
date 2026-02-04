//
//  WorkoutInsightBuilder.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

public struct WorkoutInsightBuilder {
    private let healthKitAdapter: HealthKitAdapterProtocol
    private let workouts: [Workout]
    private let includeHeartRate: Bool
    private let windowDays: Int

    public init(
        healthKitAdapter: HealthKitAdapterProtocol,
        workouts: [Workout],
        includeHeartRate: Bool,
        windowDays: Int = 7
    ) {
        self.healthKitAdapter = healthKitAdapter
        self.workouts = workouts
        self.includeHeartRate = includeHeartRate
        self.windowDays = windowDays
    }

    public func build() async -> WorkoutHighlightsInsight? {
        let calendar = Calendar.current
        let windowEnd = Date()
        guard let windowStart = calendar.date(byAdding: .day, value: -windowDays, to: windowEnd) else { return nil }

        let recentWorkouts = workouts.filter { $0.startedAt >= windowStart && $0.startedAt <= windowEnd }
            .sorted { $0.startedAt > $1.startedAt }

        guard !recentWorkouts.isEmpty else { return nil }

        var summaries: [WorkoutInsightSummary] = []
        summaries.reserveCapacity(recentWorkouts.count)

        var allHeartRates: [HeartRateReading] = []

        for workout in recentWorkouts {
            guard !Task.isCancelled else { return nil }
            let durationSeconds = workout.durationSeconds ?? workout.endedAt.timeIntervalSince(workout.startedAt)
            let durationMinutes = max(0, durationSeconds / 60)

            var averageHeartRate: Double?
            var peakHeartRate: Double?

            if includeHeartRate {
                let readings = await healthKitAdapter.heartRateReadings(from: workout.startedAt, to: workout.endedAt)
                allHeartRates.append(contentsOf: readings)
                if let average = WorkoutRouteMetrics.averageHeartRate(readings: readings) {
                    averageHeartRate = average
                }
                peakHeartRate = readings.map(\.bpm).max()
            }

            summaries.append(
                WorkoutInsightSummary(
                    id: workout.id,
                    type: workout.type,
                    startedAt: workout.startedAt,
                    durationMinutes: durationMinutes,
                    distanceMeters: workout.totalDistanceMeters,
                    averageHeartRate: averageHeartRate,
                    peakHeartRate: peakHeartRate
                )
            )
        }

        let totalDurationMinutes = summaries.map(\.durationMinutes).reduce(0, +)
        let totalDistanceMeters = totalDistance(recentWorkouts)
        let averageHeartRate = WorkoutRouteMetrics.averageHeartRate(readings: allHeartRates)
        let peakHeartRate = allHeartRates.map(\.bpm).max()

        let mostIntense = summaries
            .sorted { (lhs, rhs) -> Bool in
                let lhsValue = lhs.averageHeartRate ?? lhs.peakHeartRate ?? 0
                let rhsValue = rhs.averageHeartRate ?? rhs.peakHeartRate ?? 0
                return lhsValue > rhsValue
            }
            .first

        let longest = summaries.max { $0.durationMinutes < $1.durationMinutes }

        return WorkoutHighlightsInsight(
            windowStart: windowStart,
            windowEnd: windowEnd,
            workoutCount: summaries.count,
            totalDurationMinutes: totalDurationMinutes,
            totalDistanceMeters: totalDistanceMeters,
            averageHeartRate: averageHeartRate,
            peakHeartRate: peakHeartRate,
            mostIntenseWorkout: mostIntense,
            longestWorkout: longest,
            recentWorkouts: Array(summaries.prefix(6))
        )
    }

    private func totalDistance(_ workouts: [Workout]) -> Double? {
        let values = workouts.compactMap(\.totalDistanceMeters)
        guard !values.isEmpty else { return nil }
        return values.reduce(0, +)
    }
}
