//
//  MetricsRange.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum MetricsRange: String, CaseIterable, Hashable, Identifiable, Sendable {
    case day
    case week
    case month

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .day:
            return "Day"
        case .week:
            return "Week"
        case .month:
            return "Month"
        }
    }

    public init() {
        self = .day
    }
}
