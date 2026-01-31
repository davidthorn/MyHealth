//
//  MetricsCategory.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum MetricsCategory: String, CaseIterable, Hashable, Sendable {
    case heartRate
    case steps
    case calories
    case sleep

    public var title: String {
        switch self {
        case .heartRate:
            return "Heart Rate"
        case .steps:
            return "Steps"
        case .calories:
            return "Calories"
        case .sleep:
            return "Sleep"
        }
    }
}
