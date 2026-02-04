//
//  ActivityInsightBuilder.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct ActivityInsightBuilder {
    private let summary: ActivityRingsSummary?
    private let windowDays: Int

    public init(summary: ActivityRingsSummary?, windowDays: Int = 7) {
        self.summary = summary
        self.windowDays = windowDays
    }

    public func build() -> ActivityHighlightsInsight? {
        guard let summary else { return nil }
        var days: [ActivityRingsDay] = []
        if let latest = summary.latest {
            days.append(latest)
        }
        days.append(contentsOf: summary.previous)

        let sortedDays = days.sorted { $0.date > $1.date }
        let recentDays = Array(sortedDays.prefix(windowDays))
        let previousDays = Array(sortedDays.dropFirst(windowDays).prefix(windowDays))
        guard !recentDays.isEmpty else { return nil }

        let totalDays = recentDays.count
        let totalMove = recentDays.map(\.moveValue).reduce(0, +)
        let totalExercise = recentDays.map(\.exerciseMinutes).reduce(0, +)
        let totalStand = recentDays.map(\.standHours).reduce(0, +)
        let activeDays = recentDays.filter { $0.exerciseMinutes > 0 }.count
        let daysWithRingClosed = recentDays.filter { $0.closedRingsCount > 0 }.count

        let bestDay = recentDays.max { $0.moveValue < $1.moveValue }
        let bestDayMove = bestDay?.moveValue ?? 0
        let worstDay = recentDays.min { $0.moveValue < $1.moveValue }
        let worstDayMove = worstDay?.moveValue ?? 0

        let averageMove = totalMove / Double(totalDays)
        let averageExercise = totalExercise / Double(totalDays)
        let averageStand = totalStand / Double(totalDays)
        let averageMoveGoal = averageGoal(for: recentDays, metric: .move)
        let averageExerciseGoal = averageGoal(for: recentDays, metric: .exercise)
        let averageStandGoal = averageGoal(for: recentDays, metric: .stand)

        return ActivityHighlightsInsight(
            recentDays: recentDays,
            previousDays: previousDays,
            totalMove: totalMove,
            totalExerciseMinutes: totalExercise,
            totalStandHours: totalStand,
            activeDays: activeDays,
            daysWithRingClosed: daysWithRingClosed,
            bestDayDate: bestDay?.date,
            bestDayMove: bestDayMove,
            worstDayDate: worstDay?.date,
            worstDayMove: worstDayMove,
            averageMove: averageMove,
            averageExercise: averageExercise,
            averageStand: averageStand,
            averageMoveGoal: averageMoveGoal,
            averageExerciseGoal: averageExerciseGoal,
            averageStandGoal: averageStandGoal
        )
    }

    private func averageGoal(for days: [ActivityRingsDay], metric: ActivityRingsMetric) -> Double {
        guard !days.isEmpty else { return 0 }
        let values = days.compactMap { day -> Double? in
            switch metric {
            case .move:
                guard day.moveGoal > 0 else { return nil }
                return day.moveGoal
            case .exercise:
                guard day.exerciseGoal > 0 else { return nil }
                return day.exerciseGoal
            case .stand:
                guard day.standGoal > 0 else { return nil }
                return day.standGoal
            }
        }
        guard !values.isEmpty else { return 0 }
        return values.reduce(0, +) / Double(values.count)
    }
}
