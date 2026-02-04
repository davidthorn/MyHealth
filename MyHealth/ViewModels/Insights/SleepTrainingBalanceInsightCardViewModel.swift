//
//  SleepTrainingBalanceInsightCardViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models
import SwiftUI

public final class SleepTrainingBalanceInsightCardViewModel: ObservableObject {
    public let insight: InsightItem

    public init(insight: InsightItem) {
        self.insight = insight
    }

    public var title: String { insight.title }
    public var statusText: String { insight.status }
    public var summaryText: String { insight.summary }
    public var detailText: String { insight.detail }
    public var iconName: String { insight.icon }

    public var sleepText: String {
        guard let hours = insight.sleepTrainingBalance?.currentSleepHours else { return "—" }
        return "\(formatNumber(hours)) hr"
    }

    public var loadText: String {
        guard let minutes = insight.sleepTrainingBalance?.currentLoadMinutes else { return "—" }
        return "\(formatNumber(minutes)) min"
    }

    public var statusColor: Color {
        guard let status = insight.sleepTrainingBalance?.status else { return .gray }
        switch status {
        case .balanced:
            return .indigo
        case .underRecovered:
            return .orange
        case .wellRecovered:
            return .green
        case .unclear:
            return .gray
        }
    }

    private func formatNumber(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}
