//
//  WorkoutLoadTrendInsightDetailViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models

public final class WorkoutLoadTrendInsightDetailViewModel: ObservableObject {
    public let insight: InsightItem

    public init(insight: InsightItem) {
        self.insight = insight
    }

    public var title: String {
        insight.title
    }

    public var currentSummaryText: String {
        guard let insight = insight.workoutLoadTrend else { return "—" }
        return "\(formatNumber(insight.currentMinutes)) min • \(insight.currentWorkoutCount) workouts"
    }

    public var previousSummaryText: String {
        guard let insight = insight.workoutLoadTrend else { return "—" }
        return "\(formatNumber(insight.previousMinutes)) min • \(insight.previousWorkoutCount) workouts"
    }

    public var currentWeekLabel: String {
        guard let insight = insight.workoutLoadTrend else { return "This week" }
        return "This week \(dateRangeText(start: insight.currentWeekStart, end: insight.currentWeekEnd))"
    }

    public var previousWeekLabel: String {
        guard let insight = insight.workoutLoadTrend else { return "Last week" }
        return "Last week \(dateRangeText(start: insight.previousWeekStart, end: insight.previousWeekEnd))"
    }

    public var loadComparisonText: String {
        guard let insight = insight.workoutLoadTrend else { return "—" }
        guard let current = insight.currentLoad, let previous = insight.previousLoad else { return "—" }
        return "\(formatNumber(current)) vs \(formatNumber(previous))"
    }

    public var workoutCountText: String {
        guard let insight = insight.workoutLoadTrend else { return "—" }
        return "\(insight.currentWorkoutCount) vs \(insight.previousWorkoutCount)"
    }

    public var interpretationText: String {
        guard let status = insight.workoutLoadTrend?.status else { return "Load data unavailable." }
        switch status {
        case .rampingUp:
            return "You did more work than last week. Great progress—build gradually to avoid fatigue."
        case .steady:
            return "Your training load is steady. Consistency like this supports long-term gains."
        case .tapering:
            return "You did less work than last week. This can support recovery or indicate a lighter week."
        case .unclear:
            return "Not enough data to compare weekly load."
        }
    }

    private func formatNumber(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "\(Int(value.rounded()))"
    }

    private func dateRangeText(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let endDay = Calendar.current.date(byAdding: .day, value: -1, to: end) ?? end
        return "\(formatter.string(from: start))–\(formatter.string(from: endDay))"
    }
}
