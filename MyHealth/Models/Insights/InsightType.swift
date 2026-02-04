//
//  InsightType.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum InsightType: String, Hashable, CaseIterable, Sendable, Identifiable {
    case activityConsistency

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .activityConsistency:
            return "Activity Consistency"
        }
    }
}
