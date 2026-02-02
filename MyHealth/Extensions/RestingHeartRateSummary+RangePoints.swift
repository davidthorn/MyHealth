//
//  RestingHeartRateSummary+RangePoints.swift
//  MyHealth
//
//  Created by Codex.
//

import Models

public extension RestingHeartRateSummary {
    func rangePoints() -> [HeartRateRangePoint] {
        let days = previous + (latest.map { [$0] } ?? [])
        return days.sorted { $0.date < $1.date }.map { day in
            HeartRateRangePoint(date: day.date, bpm: day.averageBpm)
        }
    }
}
