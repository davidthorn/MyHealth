//
//  WorkoutIntensityDistributionInsightCardViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models
import SwiftUI

public final class WorkoutIntensityDistributionInsightCardViewModel: ObservableObject {
    public let insight: InsightItem

    public init(insight: InsightItem) {
        self.insight = insight
    }

    public var title: String { insight.title }
    public var statusText: String { insight.status }
    public var summaryText: String { insight.summary }
    public var detailText: String { insight.detail }
    public var iconName: String { insight.icon }

    public var lowMinutesText: String {
        formatNumber(insight.workoutIntensityDistribution?.lowMinutes)
    }

    public var moderateMinutesText: String {
        formatNumber(insight.workoutIntensityDistribution?.moderateMinutes)
    }

    public var highMinutesText: String {
        formatNumber(insight.workoutIntensityDistribution?.highMinutes)
    }

    public var lowFraction: Double {
        fraction(for: .low)
    }

    public var moderateFraction: Double {
        fraction(for: .moderate)
    }

    public var highFraction: Double {
        fraction(for: .high)
    }

    public var statusColor: Color {
        guard let status = insight.workoutIntensityDistribution?.status else { return .gray }
        switch status {
        case .balanced:
            return .mint
        case .lowBias:
            return .blue
        case .moderateBias:
            return .orange
        case .highBias:
            return .red
        case .unclear:
            return .gray
        }
    }

    private func formatNumber(_ value: Double?) -> String {
        guard let value else { return "—" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "\(Int(value.rounded()))"
    }

    private func fraction(for zone: WorkoutIntensityZone) -> Double {
        guard let detail = insight.workoutIntensityDistribution else { return 0 }
        let total = detail.lowMinutes + detail.moderateMinutes + detail.highMinutes
        guard total > 0 else { return 0 }
        switch zone {
        case .low:
            return detail.lowMinutes / total
        case .moderate:
            return detail.moderateMinutes / total
        case .high:
            return detail.highMinutes / total
        }
    }
}
