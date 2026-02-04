//
//  RecoveryReadinessInsightBuilder.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

public struct RecoveryReadinessInsightBuilder {
    private let healthKitAdapter: HealthKitAdapterProtocol
    private let includeResting: Bool
    private let includeHrv: Bool
    private let windowDays: Int

    public init(
        healthKitAdapter: HealthKitAdapterProtocol,
        includeResting: Bool,
        includeHrv: Bool,
        windowDays: Int = 14
    ) {
        self.healthKitAdapter = healthKitAdapter
        self.includeResting = includeResting
        self.includeHrv = includeHrv
        self.windowDays = windowDays
    }

    public func build() async -> RecoveryReadinessInsight? {
        guard includeResting || includeHrv else { return nil }

        let windowEnd = Date()
        let calendar = Calendar.current
        guard let windowStart = calendar.date(byAdding: .day, value: -windowDays, to: windowEnd) else { return nil }

        var restingDays: [RestingHeartRateDay] = []
        if includeResting {
            let summary = await firstValue(from: healthKitAdapter.restingHeartRateSummaryStream(days: windowDays))
            if let summary {
                if let latest = summary.latest {
                    restingDays.append(latest)
                }
                restingDays.append(contentsOf: summary.previous)
            }
        }

        let hrvDays = includeHrv ? await healthKitAdapter.hrvProvider.dailyStats(days: windowDays) : []

        guard !restingDays.isEmpty || !hrvDays.isEmpty else { return nil }

        let latestResting = restingDays.sorted { $0.date > $1.date }.first?.averageBpm
        let latestHrv = hrvDays.sorted { $0.date > $1.date }.first?.averageMilliseconds

        let restingTrend = trend(
            current: averageForLast7Days(restingDays.map { ($0.date, $0.averageBpm) }),
            previous: averageForPrevious7Days(restingDays.map { ($0.date, $0.averageBpm) }),
            threshold: 1.0
        )

        let hrvTrend = trend(
            current: averageForLast7Days(hrvDays.compactMap { day in
                guard let value = day.averageMilliseconds else { return nil }
                return (day.date, value)
            }),
            previous: averageForPrevious7Days(hrvDays.compactMap { day in
                guard let value = day.averageMilliseconds else { return nil }
                return (day.date, value)
            }),
            threshold: 2.0
        )

        let currentRestingAverage = averageForLast7Days(restingDays.map { ($0.date, $0.averageBpm) })
        let previousRestingAverage = averageForPrevious7Days(restingDays.map { ($0.date, $0.averageBpm) })
        let currentHrvAverage = averageForLast7Days(hrvDays.compactMap { day in
            guard let value = day.averageMilliseconds else { return nil }
            return (day.date, value)
        })
        let previousHrvAverage = averageForPrevious7Days(hrvDays.compactMap { day in
            guard let value = day.averageMilliseconds else { return nil }
            return (day.date, value)
        })

        let status = recoveryStatus(restingTrend: restingTrend, hrvTrend: hrvTrend)

        return RecoveryReadinessInsight(
            windowStart: windowStart,
            windowEnd: windowEnd,
            latestRestingBpm: latestResting,
            latestHrvMilliseconds: latestHrv,
            currentRestingAverage: currentRestingAverage,
            previousRestingAverage: previousRestingAverage,
            currentHrvAverage: currentHrvAverage,
            previousHrvAverage: previousHrvAverage,
            restingTrend: restingTrend,
            hrvTrend: hrvTrend,
            status: status
        )
    }

    private func firstValue<T>(from stream: AsyncStream<T>) async -> T? {
        for await value in stream {
            return value
        }
        return nil
    }

    private func averageForLast7Days(_ values: [(Date, Double)]) -> Double? {
        let calendar = Calendar.current
        let windowEnd = Date()
        guard let windowStart = calendar.date(byAdding: .day, value: -7, to: windowEnd) else { return nil }
        let filtered = values.filter { $0.0 >= windowStart && $0.0 <= windowEnd }
        guard !filtered.isEmpty else { return nil }
        return filtered.map(\.1).reduce(0, +) / Double(filtered.count)
    }

    private func averageForPrevious7Days(_ values: [(Date, Double)]) -> Double? {
        let calendar = Calendar.current
        let windowEnd = Date()
        guard let windowStart = calendar.date(byAdding: .day, value: -14, to: windowEnd),
              let windowMid = calendar.date(byAdding: .day, value: -7, to: windowEnd) else { return nil }
        let filtered = values.filter { $0.0 >= windowStart && $0.0 < windowMid }
        guard !filtered.isEmpty else { return nil }
        return filtered.map(\.1).reduce(0, +) / Double(filtered.count)
    }

    private func trend(
        current: Double?,
        previous: Double?,
        threshold: Double
    ) -> RecoveryReadinessTrend {
        guard let current, let previous else { return .unknown }
        let delta = current - previous
        if delta > threshold {
            return .up
        }
        if delta < -threshold {
            return .down
        }
        return .steady
    }

    private func recoveryStatus(
        restingTrend: RecoveryReadinessTrend,
        hrvTrend: RecoveryReadinessTrend
    ) -> RecoveryReadinessStatus {
        switch (restingTrend, hrvTrend) {
        case (.down, .up):
            return .ready
        case (.up, .down):
            return .strained
        case (.unknown, _), (_, .unknown):
            return .unclear
        default:
            return .steady
        }
    }
}
