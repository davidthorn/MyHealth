//
//  MetricsCategory.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum MetricsCategory: String, CaseIterable, Hashable, Sendable {
    case heartRate
    case bloodOxygen
    case heartRateVariability
    case restingHeartRate
    case steps
    case flights
    case standHours
    case exerciseMinutes
    case calories
    case sleep
    case activityRings

    public var title: String {
        switch self {
        case .heartRate:
            return "Heart Rate"
        case .bloodOxygen:
            return "Blood Oxygen"
        case .heartRateVariability:
            return "HRV"
        case .restingHeartRate:
            return "Resting HR"
        case .steps:
            return "Steps"
        case .flights:
            return "Flights"
        case .standHours:
            return "Stand Hours"
        case .exerciseMinutes:
            return "Exercise Minutes"
        case .calories:
            return "Calories"
        case .sleep:
            return "Sleep"
        case .activityRings:
            return "Activity Rings"
        }
    }
}
