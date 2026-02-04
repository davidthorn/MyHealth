//
//  WorkoutRecoveryBalanceInsightDetailViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models

public final class WorkoutRecoveryBalanceInsightDetailViewModel: ObservableObject {
    public let insight: InsightItem

    public init(insight: InsightItem) {
        self.insight = insight
    }

    public var title: String { insight.title }

    public var statusText: String { insight.status }

    public var summaryText: String { insight.summary }

    public var detailText: String { insight.detail }

    public var loadMinutesText: String {
        guard let detail = insight.workoutRecoveryBalance else { return "—" }
        if let minutes = detail.loadMinutes {
            return "\(formatNumber(minutes)) min"
        }
        return "—"
    }

    public var loadScoreText: String {
        guard let detail = insight.workoutRecoveryBalance else { return "—" }
        if let score = detail.loadScore {
            return formatNumber(score)
        }
        return "—"
    }

    public var workoutCountText: String {
        guard let detail = insight.workoutRecoveryBalance else { return "—" }
        return "\(detail.workoutCount) workouts"
    }

    public var currentWeekLabel: String {
        guard let detail = insight.workoutRecoveryBalance else { return "This week" }
        return "This week \(dateRangeText(start: detail.currentWeekStart, end: detail.currentWeekEnd))"
    }

    public var recoveryStatusText: String {
        insight.workoutRecoveryBalance?.recoveryStatus?.title ?? "Unknown"
    }

    public var restingTrendText: String {
        insight.workoutRecoveryBalance?.restingTrend?.label ?? "No Data"
    }

    public var hrvTrendText: String {
        insight.workoutRecoveryBalance?.hrvTrend?.label ?? "No Data"
    }

    public var latestRestingText: String {
        guard let bpm = insight.workoutRecoveryBalance?.latestRestingBpm else { return "—" }
        return "\(formatNumber(bpm)) bpm"
    }

    public var latestHrvText: String {
        guard let ms = insight.workoutRecoveryBalance?.latestHrvMilliseconds else { return "—" }
        return "\(formatNumber(ms)) ms"
    }

    public var interpretationText: String {
        guard let status = insight.workoutRecoveryBalance?.status else { return "Balance data unavailable." }
        switch status {
        case .balanced:
            return "Your recent training load aligns well with recovery signals. Keep this rhythm going."
        case .overreaching:
            return "Recovery signals are strained relative to training load. Consider an easier session or extra rest."
        case .readyForMore:
            return "Recovery looks strong with a lighter load. You could safely add a little intensity."
        case .unclear:
            return "Not enough data to compare training load with recovery signals."
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
