//
//  RestingHeartRateSummaryService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

@MainActor
public final class RestingHeartRateSummaryService: RestingHeartRateSummaryServiceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(healthKitAdapter: HealthKitAdapterProtocol) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func requestAuthorization() async -> Bool {
        await healthKitAdapter.authorizationProvider.requestRestingHeartRateAuthorization()
    }

    public func updates() -> AsyncStream<RestingHeartRateSummaryUpdate> {
        AsyncStream { continuation in
            let task = Task { [healthKitAdapter] in
                for await summary in healthKitAdapter.restingHeartRateSummaryStream(days: 14) {
                    guard !Task.isCancelled else { return }
                    continuation.yield(RestingHeartRateSummaryUpdate(summary: summary))
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
