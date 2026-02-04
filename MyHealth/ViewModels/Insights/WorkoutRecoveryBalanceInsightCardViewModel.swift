//
//  WorkoutRecoveryBalanceInsightCardViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models
import SwiftUI

public final class WorkoutRecoveryBalanceInsightCardViewModel: ObservableObject {
    public let insight: InsightItem

    public init(insight: InsightItem) {
        self.insight = insight
    }

    public var title: String { insight.title }
    public var statusText: String { insight.status }
    public var summaryText: String { insight.summary }
    public var detailText: String { insight.detail }
    public var iconName: String { insight.icon }

    public var loadText: String {
        guard let detail = insight.workoutRecoveryBalance else { return "—" }
        if let minutes = detail.loadMinutes {
            return "\(formatNumber(minutes)) min"
        }
        return "—"
    }

    public var recoveryText: String {
        guard let detail = insight.workoutRecoveryBalance else { return "—" }
        return detail.recoveryStatus?.title ?? "Unknown"
    }

    public var statusColor: Color {
        guard let status = insight.workoutRecoveryBalance?.status else { return .gray }
        switch status {
        case .balanced:
            return .green
        case .overreaching:
            return .orange
        case .readyForMore:
            return .blue
        case .unclear:
            return .gray
        }
    }

    private func formatNumber(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "\(Int(value.rounded()))"
    }
}
