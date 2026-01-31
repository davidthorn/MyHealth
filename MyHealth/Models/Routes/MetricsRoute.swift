//
//  MetricsRoute.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum MetricsRoute: Hashable {
    case metric(MetricsCategory)

    public init(metric: MetricsCategory) {
        self = .metric(metric)
    }
}
