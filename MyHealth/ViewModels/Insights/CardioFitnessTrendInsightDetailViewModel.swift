//
//  CardioFitnessTrendInsightDetailViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models

public final class CardioFitnessTrendInsightDetailViewModel: ObservableObject {
    public let insight: InsightItem

    public init(insight: InsightItem) {
        self.insight = insight
    }

    public var title: String { insight.title }

    public var statusText: String { insight.status }

    public var summaryText: String { insight.summary }

    public var detailText: String { insight.detail }

    public var latestValueText: String {
        guard let latest = insight.cardioFitnessTrend?.latestReading else { return "—" }
        return formatNumber(latest.vo2Max)
    }

    public var latestDateText: String {
        guard let latest = insight.cardioFitnessTrend?.latestReading else { return "—" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: latest.date)
    }

    public var currentAverageText: String {
        guard let value = insight.cardioFitnessTrend?.currentAverage else { return "—" }
        return formatNumber(value)
    }

    public var previousAverageText: String {
        guard let value = insight.cardioFitnessTrend?.previousAverage else { return "—" }
        return formatNumber(value)
    }

    public var deltaText: String {
        guard let delta = insight.cardioFitnessTrend?.delta else { return "—" }
        let sign = delta >= 0 ? "+" : "–"
        return "\(sign)\(formatNumber(abs(delta)))"
    }

    public var readings: [CardioFitnessReading] {
        insight.cardioFitnessTrend?.readings ?? []
    }

    public var window: CardioFitnessWindow { .sixMonths }

    private func formatNumber(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}
