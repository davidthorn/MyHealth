//
//  SleepTrainingBalanceInsightDetailViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models

public final class SleepTrainingBalanceInsightDetailViewModel: ObservableObject {
    public let insight: InsightItem

    public init(insight: InsightItem) {
        self.insight = insight
    }

    public var title: String { insight.title }

    public var currentWeekLabel: String {
        guard let detail = insight.sleepTrainingBalance else { return "This week" }
        return "This week \(dateRangeText(start: detail.currentWeekStart, end: detail.currentWeekEnd))"
    }

    public var previousWeekLabel: String {
        guard let detail = insight.sleepTrainingBalance else { return "Last week" }
        return "Last week \(dateRangeText(start: detail.previousWeekStart, end: detail.previousWeekEnd))"
    }

    public var sleepAverageText: String {
        guard let detail = insight.sleepTrainingBalance else { return "—" }
        return formatNumber(detail.currentSleepHours)
    }

    public var sleepPreviousText: String {
        guard let detail = insight.sleepTrainingBalance else { return "—" }
        return formatNumber(detail.previousSleepHours)
    }

    public var sleepDeltaText: String {
        guard let detail = insight.sleepTrainingBalance else { return "—" }
        return deltaText(detail.sleepDeltaHours, unit: "hr")
    }

    public var loadAverageText: String {
        guard let detail = insight.sleepTrainingBalance else { return "—" }
        return formatNumber(detail.currentLoadMinutes)
    }

    public var loadPreviousText: String {
        guard let detail = insight.sleepTrainingBalance else { return "—" }
        return formatNumber(detail.previousLoadMinutes)
    }

    public var loadDeltaText: String {
        guard let detail = insight.sleepTrainingBalance else { return "—" }
        return deltaText(detail.loadDeltaMinutes, unit: "min")
    }

    public var statusText: String { insight.status }

    public var interpretationText: String {
        guard let status = insight.sleepTrainingBalance?.status else { return "Balance data unavailable." }
        switch status {
        case .balanced:
            return "Sleep has kept pace with recent training load. Keep this rhythm going."
        case .underRecovered:
            return "Training load rose while sleep dipped. Consider extra rest or shorter sessions."
        case .wellRecovered:
            return "Sleep increased while load eased. You look well‑recovered for the next session."
        case .unclear:
            return "Not enough data to compare sleep and training load."
        }
    }

    private func formatNumber(_ value: Double?) -> String {
        guard let value else { return "—" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    private func formatNumber(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    private func deltaText(_ value: Double?, unit: String) -> String {
        guard let value else { return "—" }
        let sign = value >= 0 ? "+" : "–"
        return "\(sign)\(formatNumber(abs(value))) \(unit)"
    }

    private func dateRangeText(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let endDay = Calendar.current.date(byAdding: .day, value: -1, to: end) ?? end
        return "\(formatter.string(from: start))–\(formatter.string(from: endDay))"
    }
}
