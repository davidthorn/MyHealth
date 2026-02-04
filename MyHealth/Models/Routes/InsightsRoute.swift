//
//  InsightsRoute.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum InsightsRoute: Hashable {
    case main
    case insight(InsightItem)

    public init(insight: InsightItem) {
        self = .insight(insight)
    }
}
