//
//  MetricsSummaryCard.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct MetricsSummaryCard: Hashable, Sendable {
    public let category: MetricsCategory
    public let value: String
    public let subtitle: String
    public let trend: String

    public init(category: MetricsCategory, value: String, subtitle: String, trend: String) {
        self.category = category
        self.value = value
        self.subtitle = subtitle
        self.trend = trend
    }
}
