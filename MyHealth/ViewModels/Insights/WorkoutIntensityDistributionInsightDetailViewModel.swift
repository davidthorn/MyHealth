//
//  WorkoutIntensityDistributionInsightDetailViewModel.swift
//  MyHealth
//
//  Created by Codex.
//

import Combine
import Foundation
import Models

public final class WorkoutIntensityDistributionInsightDetailViewModel: ObservableObject {
    public let insight: InsightItem

    public init(insight: InsightItem) {
        self.insight = insight
    }

    public var title: String { insight.title }

    public var statusText: String { insight.status }

    public var summaryText: String { insight.summary }

    public var lowMinutesText: String { formatNumber(insight.workoutIntensityDistribution?.lowMinutes) }

    public var moderateMinutesText: String { formatNumber(insight.workoutIntensityDistribution?.moderateMinutes) }

    public var highMinutesText: String { formatNumber(insight.workoutIntensityDistribution?.highMinutes) }

    public var lowFraction: Double { fraction(for: .low) }

    public var moderateFraction: Double { fraction(for: .moderate) }

    public var highFraction: Double { fraction(for: .high) }

    public var interpretationText: String {
        guard let status = insight.workoutIntensityDistribution?.status else { return "Intensity data unavailable." }
        switch status {
        case .lowBias:
            return "Most of your training stayed in low intensity. Add some moderate sessions if you want faster gains."
        case .moderateBias:
            return "You are spending most time in moderate intensity. Consider mixing in easy and hard days."
        case .highBias:
            return "A large share of training is high intensity. Balance with recovery or easy sessions to avoid burnout."
        case .balanced:
            return "Your intensity mix looks balanced across low, moderate, and high effort."
        case .unclear:
            return "Not enough data to determine intensity balance."
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
