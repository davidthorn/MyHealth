//
//  WorkoutIntensityDistributionInsightBuilder.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

public struct WorkoutIntensityDistributionInsightBuilder {
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

    public func build() async -> WorkoutIntensityDistributionInsight? {
        let calendar = Calendar.current
        let windowEnd = Date()
        let endDay = calendar.startOfDay(for: windowEnd)
        guard let windowStart = calendar.date(byAdding: .day, value: -(windowDays - 1), to: endDay) else { return nil }

        let filtered = workouts.filter { $0.startedAt >= windowStart && $0.startedAt <= windowEnd }
        guard !filtered.isEmpty else { return nil }

        var lowMinutes: Double = 0
        var moderateMinutes: Double = 0
        var highMinutes: Double = 0

        for workout in filtered {
            guard !Task.isCancelled else { return nil }
            let durationMinutes = max(0, (workout.durationSeconds ?? workout.endedAt.timeIntervalSince(workout.startedAt)) / 60)
            let zone = await intensityZone(for: workout)
            switch zone {
            case .low:
                lowMinutes += durationMinutes
            case .moderate:
                moderateMinutes += durationMinutes
            case .high:
                highMinutes += durationMinutes
            }
        }

        let status = determineStatus(low: lowMinutes, moderate: moderateMinutes, high: highMinutes)

        return WorkoutIntensityDistributionInsight(
            windowStart: windowStart,
            windowEnd: windowEnd,
            lowMinutes: lowMinutes,
            moderateMinutes: moderateMinutes,
            highMinutes: highMinutes,
            workoutCount: filtered.count,
            status: status
        )
    }

    private func intensityZone(for workout: Workout) async -> WorkoutIntensityZone {
        if includeHeartRate {
            let readings = await healthKitAdapter.heartRateReadings(from: workout.startedAt, to: workout.endedAt)
            if let average = WorkoutRouteMetrics.averageHeartRate(readings: readings) {
                return zone(forAverageHeartRate: average)
            }
        }
        return zone(forType: workout.type)
    }

    private func zone(forAverageHeartRate average: Double) -> WorkoutIntensityZone {
        if average < 110 {
            return .low
        }
        if average < 140 {
            return .moderate
        }
        return .high
    }

    private func zone(forType type: WorkoutType) -> WorkoutIntensityZone {
        switch type {
        case .walking, .yoga:
            return .low
        case .running:
            return .high
        case .cycling, .swimming, .strength, .other:
            return .moderate
        @unknown default:
            fatalError()
        }
    }

    private func determineStatus(low: Double, moderate: Double, high: Double) -> WorkoutIntensityBalanceStatus {
        let total = low + moderate + high
        guard total > 0 else { return .unclear }
        let lowPct = low / total
        let moderatePct = moderate / total
        let highPct = high / total

        if lowPct >= 0.6 {
            return .lowBias
        }
        if highPct >= 0.4 {
            return .highBias
        }
        if moderatePct >= 0.5 {
            return .moderateBias
        }
        return .balanced
    }
}
