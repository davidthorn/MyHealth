//
//  RestingHeartRateHistoryService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

@MainActor
public final class RestingHeartRateHistoryService: RestingHeartRateHistoryServiceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(healthKitAdapter: HealthKitAdapterProtocol) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func requestAuthorization() async -> Bool {
        await healthKitAdapter.requestRestingHeartRateAuthorization()
    }

    public func updates() -> AsyncStream<RestingHeartRateHistoryUpdate> {
        AsyncStream { continuation in
            let task = Task { [healthKitAdapter] in
                for await summary in healthKitAdapter.restingHeartRateSummaryStream(days: 30) {
                    guard !Task.isCancelled else { return }
                    continuation.yield(RestingHeartRateHistoryUpdate(summary: summary))
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
