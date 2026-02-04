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
    case workoutRecoveryBalance
    case cardioFitnessTrend
    case sleepTrainingBalance
    case workoutIntensityDistribution

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
        case .workoutRecoveryBalance:
            return "Workout Recovery Balance"
        case .cardioFitnessTrend:
            return "VO₂ Max Trend"
        case .sleepTrainingBalance:
            return "Sleep vs Training"
        case .workoutIntensityDistribution:
            return "Workout Intensity"
        }
    }
}
