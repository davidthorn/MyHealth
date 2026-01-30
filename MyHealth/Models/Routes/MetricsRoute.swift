//
//  MetricsRoute.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum MetricsRoute: Hashable {
    case metric(String)

    public init(metric: String) {
        self = .metric(metric)
    }
}
