//
//  RestingHeartRateSummary+Metrics.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public extension RestingHeartRateSummary {
    var minAverageBpm: Double? {
        days.map(\.averageBpm).min()
    }

    var maxAverageBpm: Double? {
        days.map(\.averageBpm).max()
    }

    var averageBpm: Double? {
        let values = days.map(\.averageBpm)
        guard !values.isEmpty else { return nil }
        let total = values.reduce(0, +)
        return total / Double(values.count)
    }

    var latestDeltaBpm: Double? {
        guard let latest, let previous = previous.first else { return nil }
        return latest.averageBpm - previous.averageBpm
    }

    var days: [RestingHeartRateDay] {
        (latest.map { [$0] } ?? []) + previous
    }
}
