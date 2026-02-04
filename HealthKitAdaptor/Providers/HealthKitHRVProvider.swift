//
//  HealthKitHRVProvider.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import Models

public final class HealthKitHRVProvider: HealthKitHRVProviding {
    private let storeAdaptor: HealthStoreAdaptorProtocol

    public init(storeAdaptor: HealthStoreAdaptorProtocol) {
        self.storeAdaptor = storeAdaptor
    }

    public func summaryStream() -> AsyncStream<HeartRateVariabilitySummary> {
        AsyncStream { continuation in
            let task = Task { [storeAdaptor] in
                let readings = await storeAdaptor.fetchHeartRateVariabilityReadings(limit: 20)
                guard !Task.isCancelled else { return }
                let latest = readings.first
                let previous = Array(readings.dropFirst())
                continuation.yield(HeartRateVariabilitySummary(latest: latest, previous: previous))
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    public func reading(id: UUID) async throws -> HeartRateVariabilityReading {
        try await storeAdaptor.fetchHeartRateVariabilityReading(id: id)
    }

    public func readings(start: Date, end: Date) async -> [HeartRateVariabilityReading] {
        await storeAdaptor.fetchHeartRateVariabilityReadings(start: start, end: end)
    }

    public func dailyStats(days: Int) async -> [HeartRateVariabilityDayStats] {
        await storeAdaptor.fetchHeartRateVariabilityDailyStats(days: days)
    }
}
