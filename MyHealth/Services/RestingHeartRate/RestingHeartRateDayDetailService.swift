//
//  RestingHeartRateDayDetailService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

@MainActor
public final class RestingHeartRateDayDetailService: RestingHeartRateDayDetailServiceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(healthKitAdapter: HealthKitAdapterProtocol) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func requestAuthorization() async -> Bool {
        await healthKitAdapter.authorizationProvider.requestRestingHeartRateAuthorization()
    }

    public func updates(for date: Date) -> AsyncStream<RestingHeartRateDayDetailUpdate> {
        AsyncStream { continuation in
            let task = Task { [healthKitAdapter] in
                let readings = await healthKitAdapter.restingHeartRateReadings(on: date)
                guard !Task.isCancelled else { return }
                continuation.yield(RestingHeartRateDayDetailUpdate(readings: readings))
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    public func rangeUpdates(start: Date, end: Date) -> AsyncStream<[HeartRateReading]> {
        AsyncStream { continuation in
            let task = Task { [healthKitAdapter] in
                let isAuthorized = await healthKitAdapter.authorizationProvider.requestHeartRateAuthorization()
                guard isAuthorized, !Task.isCancelled else {
                    continuation.finish()
                    return
                }
                let readings = await healthKitAdapter.heartRateReadings(from: start, to: end)
                guard !Task.isCancelled else { return }
                continuation.yield(readings)
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
