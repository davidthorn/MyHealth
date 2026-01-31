//
//  HealthKitHeartRateAdapter.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

@MainActor
public final class HealthKitHeartRateAdapter: HealthKitHeartRateAdapterProtocol {
    private let storeAdaptor: HealthStoreAdaptorProtocol

    public init(storeAdaptor: HealthStoreAdaptorProtocol) {
        self.storeAdaptor = storeAdaptor
    }

    public static func live() -> HealthKitHeartRateAdapter {
        HealthKitHeartRateAdapter(storeAdaptor: HealthStoreAdaptor())
    }

    public func requestAuthorization() async -> Bool {
        await storeAdaptor.requestHeartRateAuthorization()
    }

    public func heartRateSummaryStream() -> AsyncStream<HeartRateSummary> {
        AsyncStream { continuation in
            let task = Task { [storeAdaptor] in
                let readings = await storeAdaptor.fetchHeartRateReadings(limit: 20)
                guard !Task.isCancelled else { return }
                let latest = readings.first
                let previous = Array(readings.dropFirst())
                continuation.yield(HeartRateSummary(latest: latest, previous: previous))
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    public func heartRateReading(id: UUID) async throws -> HeartRateReading {
        try await storeAdaptor.fetchHeartRateReading(id: id)
    }

    public func heartRateReadings(start: Date, end: Date) async -> [HeartRateReading] {
        await storeAdaptor.fetchHeartRateReadings(start: start, end: end)
    }
}
