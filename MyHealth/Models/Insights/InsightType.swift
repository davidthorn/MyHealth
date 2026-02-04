//
//  InsightType.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum InsightType: String, Hashable, CaseIterable, Sendable, Identifiable {
    case activityHighlights
    case workoutHighlights
    case recoveryReadiness
    case workoutLoadTrend

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .activityHighlights:
            return "Activity Highlights"
        case .workoutHighlights:
            return "Workout Highlights"
        case .recoveryReadiness:
            return "Recovery Readiness"
        case .workoutLoadTrend:
            return "Workout Load Trend"
        }
    }
}
