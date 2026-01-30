//
//  InsightsRoute.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum InsightsRoute: Hashable {
    case insight(String)

    public init(insight: String) {
        self = .insight(insight)
    }
}
