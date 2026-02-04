//
//  HeartRateVariabilityDetailService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

public final class HeartRateVariabilityDetailService: HeartRateVariabilityDetailServiceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(healthKitAdapter: HealthKitAdapterProtocol) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func requestAuthorization() async -> Bool {
        await healthKitAdapter.authorizationProvider.requestHeartRateVariabilityAuthorization()
    }

    public func updates(window: HeartRateVariabilityWindow) -> AsyncStream<HeartRateVariabilityDetailUpdate> {
        AsyncStream { continuation in
            let task = Task { [healthKitAdapter] in
                let range = window.dateRange(endingAt: Date())
                let readings = await healthKitAdapter.hrvProvider.readings(start: range.start, end: range.end)
                let dayStats = await healthKitAdapter.hrvProvider.dailyStats(days: window.days)
                guard !Task.isCancelled else { return }
                continuation.yield(HeartRateVariabilityDetailUpdate(readings: readings, dayStats: dayStats))
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
