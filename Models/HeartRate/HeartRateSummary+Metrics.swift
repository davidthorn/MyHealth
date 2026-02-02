//
//  HeartRateSummary+Metrics.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public extension HeartRateSummary {
    var minBpm: Double? {
        readings.map(\.bpm).min()
    }

    var maxBpm: Double? {
        readings.map(\.bpm).max()
    }

    var averageBpm: Double? {
        let values = readings.map(\.bpm)
        guard !values.isEmpty else { return nil }
        let total = values.reduce(0, +)
        return total / Double(values.count)
    }

    var latestDeltaBpm: Double? {
        guard let latest, let previous = previous.first else { return nil }
        return latest.bpm - previous.bpm
    }

    var readings: [HeartRateReading] {
        (latest.map { [$0] } ?? []) + previous
    }
}
