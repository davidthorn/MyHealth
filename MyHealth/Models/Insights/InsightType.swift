//
//  InsightType.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum InsightType: String, Hashable, CaseIterable, Sendable, Identifiable {
    case activityHighlights

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .activityHighlights:
            return "Activity Highlights"
        }
    }
}
