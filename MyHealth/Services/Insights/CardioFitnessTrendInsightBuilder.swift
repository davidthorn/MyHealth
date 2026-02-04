//
//  CardioFitnessTrendInsightBuilder.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

public struct CardioFitnessTrendInsightBuilder {
    private let healthKitAdapter: HealthKitAdapterProtocol
    private let windowDays: Int
    private let trendDays: Int

    public init(
        healthKitAdapter: HealthKitAdapterProtocol,
        windowDays: Int = 180,
        trendDays: Int = 30
    ) {
        self.healthKitAdapter = healthKitAdapter
        self.windowDays = windowDays
        self.trendDays = trendDays
    }

    public func build() async -> CardioFitnessTrendInsight? {
        let windowEnd = Date()
        let calendar = Calendar.current
        guard let windowStart = calendar.date(byAdding: .day, value: -windowDays, to: windowEnd) else {
            return nil
        }
        let readings = await healthKitAdapter.cardioFitnessReadings(from: windowStart, to: windowEnd)
        guard !readings.isEmpty else { return nil }

        let dayStats = await healthKitAdapter.cardioFitnessDailyStats(days: windowDays)
        let latestReading = readings.max(by: { $0.date < $1.date })

        let currentAverage = averageValue(
            from: dayStats,
            windowEnd: windowEnd,
            days: trendDays
        ) ?? averageReading(
            readings: readings,
            start: calendar.date(byAdding: .day, value: -trendDays, to: windowEnd),
            end: windowEnd
        )

        let previousAverage = averageValue(
            from: dayStats,
            windowEnd: calendar.date(byAdding: .day, value: -trendDays, to: windowEnd) ?? windowEnd,
            days: trendDays
        ) ?? averageReading(
            readings: readings,
            start: calendar.date(byAdding: .day, value: -(trendDays * 2), to: windowEnd),
            end: calendar.date(byAdding: .day, value: -trendDays, to: windowEnd)
        )

        let delta = (currentAverage != nil && previousAverage != nil) ? (currentAverage! - previousAverage!) : nil
        let status = determineStatus(current: currentAverage, previous: previousAverage, delta: delta)

        return CardioFitnessTrendInsight(
            windowStart: windowStart,
            windowEnd: windowEnd,
            readings: readings,
            dayStats: dayStats,
            latestReading: latestReading,
            currentAverage: currentAverage,
            previousAverage: previousAverage,
            delta: delta,
            status: status
        )
    }

    private func averageValue(
        from stats: [CardioFitnessDayStats],
        windowEnd: Date,
        days: Int
    ) -> Double? {
        let calendar = Calendar.current
        guard let windowStart = calendar.date(byAdding: .day, value: -days, to: windowEnd) else { return nil }
        let filtered = stats.filter { $0.date >= windowStart && $0.date <= windowEnd }
        let values = filtered.compactMap { $0.averageVo2Max }
        guard !values.isEmpty else { return nil }
        return values.reduce(0, +) / Double(values.count)
    }

    private func averageReading(
        readings: [CardioFitnessReading],
        start: Date?,
        end: Date?
    ) -> Double? {
        guard let start, let end else { return nil }
        let values = readings.filter { $0.date >= start && $0.date <= end }.map { $0.vo2Max }
        guard !values.isEmpty else { return nil }
        return values.reduce(0, +) / Double(values.count)
    }

    private func determineStatus(
        current: Double?,
        previous: Double?,
        delta: Double?
    ) -> CardioFitnessTrendStatus {
        guard let delta, let previous, let current else { return .unclear }
        let threshold = max(0.5, previous * 0.02)
        if delta > threshold {
            return .rising
        }
        if delta < -threshold {
            return .declining
        }
        if abs(current - previous) < threshold {
            return .steady
        }
        return .steady
    }
}
