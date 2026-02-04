//
//  SleepTrainingBalanceInsightBuilder.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct SleepTrainingBalanceInsightBuilder {
    private let workouts: [Workout]
    private let sleepDays: [SleepDay]
    private let windowDays: Int

    public init(
        workouts: [Workout],
        sleepDays: [SleepDay],
        windowDays: Int = 14
    ) {
        self.workouts = workouts
        self.sleepDays = sleepDays
        self.windowDays = windowDays
    }

    public func build() -> SleepTrainingBalanceInsight? {
        let calendar = Calendar.current
        let windowEnd = Date()
        let endDay = calendar.startOfDay(for: windowEnd)
        guard let currentWeekStart = calendar.date(byAdding: .day, value: -6, to: endDay) else { return nil }
        guard let currentWeekEnd = calendar.date(byAdding: .day, value: 1, to: endDay) else { return nil }
        guard let previousWeekStart = calendar.date(byAdding: .day, value: -7, to: currentWeekStart) else { return nil }
        let previousWeekEnd = currentWeekStart
        let currentWeek = DateInterval(start: currentWeekStart, end: currentWeekEnd)
        let previousWeek = DateInterval(start: previousWeekStart, end: previousWeekEnd)
        let windowStart = previousWeekStart

        let currentSleepHours = averageSleepHours(in: currentWeek)
        let previousSleepHours = averageSleepHours(in: previousWeek)
        let sleepDelta = delta(current: currentSleepHours, previous: previousSleepHours)

        let currentWorkouts = workouts.filter { currentWeek.contains($0.startedAt) }
        let previousWorkouts = workouts.filter { previousWeek.contains($0.startedAt) }
        let currentLoadMinutes = totalMinutes(for: currentWorkouts)
        let previousLoadMinutes = totalMinutes(for: previousWorkouts)
        let loadDelta = delta(current: currentLoadMinutes, previous: previousLoadMinutes)

        let status = determineStatus(sleepDelta: sleepDelta, loadDelta: loadDelta)

        guard currentSleepHours != nil || currentLoadMinutes != nil else { return nil }

        return SleepTrainingBalanceInsight(
            windowStart: windowStart,
            windowEnd: currentWeek.end,
            currentWeekStart: currentWeekStart,
            currentWeekEnd: currentWeekEnd,
            previousWeekStart: previousWeekStart,
            previousWeekEnd: previousWeekEnd,
            currentSleepHours: currentSleepHours,
            previousSleepHours: previousSleepHours,
            sleepDeltaHours: sleepDelta,
            currentLoadMinutes: currentLoadMinutes,
            previousLoadMinutes: previousLoadMinutes,
            loadDeltaMinutes: loadDelta,
            workoutCount: currentWorkouts.count,
            status: status
        )
    }

    private func averageSleepHours(in range: DateInterval) -> Double? {
        let values = sleepDays
            .filter { range.contains($0.date) }
            .map { $0.durationSeconds / 3600 }
        guard !values.isEmpty else { return nil }
        return values.reduce(0, +) / Double(values.count)
    }

    private func totalMinutes(for workouts: [Workout]) -> Double? {
        guard !workouts.isEmpty else { return nil }
        return workouts.map { workout in
            workout.durationSeconds ?? workout.endedAt.timeIntervalSince(workout.startedAt)
        }
        .map { max(0, $0 / 60) }
        .reduce(0, +)
    }

    private func delta(current: Double?, previous: Double?) -> Double? {
        guard let current, let previous else { return nil }
        return current - previous
    }

    private func determineStatus(sleepDelta: Double?, loadDelta: Double?) -> SleepTrainingBalanceStatus {
        guard let sleepDelta, let loadDelta else { return .unclear }
        let sleepThreshold = 0.3
        let loadThreshold = 20.0

        if loadDelta > loadThreshold && sleepDelta < -sleepThreshold {
            return .underRecovered
        }
        if loadDelta < -loadThreshold && sleepDelta > sleepThreshold {
            return .wellRecovered
        }
        return .balanced
    }
}
