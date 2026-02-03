//
//  HealthKitRestingHeartRateAdapter.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import Models

public final class HealthKitRestingHeartRateAdapter: HealthKitRestingHeartRateAdapterProtocol {
    private let storeAdaptor: HealthStoreAdaptorProtocol

    public init(storeAdaptor: HealthStoreAdaptorProtocol) {
        self.storeAdaptor = storeAdaptor
    }

    public static func live() -> HealthKitRestingHeartRateAdapter {
        HealthKitRestingHeartRateAdapter(storeAdaptor: HealthStoreAdaptor())
    }

    public func requestAuthorization() async -> Bool {
        await storeAdaptor.authorizationProvider.requestRestingHeartRateAuthorization()
    }

    public func restingHeartRateSummaryStream(days: Int) -> AsyncStream<RestingHeartRateSummary> {
        AsyncStream { continuation in
            let task = Task { [storeAdaptor] in
                let safeDays = max(days, 1)
                let days = await storeAdaptor.fetchRestingHeartRateDays(days: safeDays)
                guard !Task.isCancelled else { return }
                let latest = days.first
                let previous = Array(days.dropFirst())
                continuation.yield(RestingHeartRateSummary(latest: latest, previous: previous))
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    public func restingHeartRateReadings(on date: Date) async -> [RestingHeartRateReading] {
        await storeAdaptor.fetchRestingHeartRateReadings(on: date)
    }
}
