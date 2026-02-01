//
//  HeartRateSummaryService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor

@MainActor
public final class HeartRateSummaryService: HeartRateSummaryServiceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(healthKitAdapter: HealthKitAdapterProtocol) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func requestAuthorization() async -> Bool {
        await healthKitAdapter.authorizationProvider.requestHeartRateAuthorization()
    }

    public func updates() -> AsyncStream<HeartRateSummaryUpdate> {
        AsyncStream { continuation in
            let task = Task { [healthKitAdapter] in
                for await summary in healthKitAdapter.heartRateSummaryStream() {
                    if Task.isCancelled { break }
                    continuation.yield(HeartRateSummaryUpdate(summary: summary))
                }
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
