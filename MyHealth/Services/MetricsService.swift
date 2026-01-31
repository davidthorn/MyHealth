//
//  MetricsService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

@MainActor
public final class MetricsService: MetricsServiceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(healthKitAdapter: HealthKitAdapterProtocol) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func updates() -> AsyncStream<MetricsUpdate> {
        AsyncStream { continuation in
            let task = Task { [healthKitAdapter] in
                continuation.yield(MetricsUpdate(title: "Metrics", restingHeartRateSummary: nil))
                let isAuthorized = await healthKitAdapter.requestRestingHeartRateAuthorization()
                guard isAuthorized, !Task.isCancelled else {
                    continuation.finish()
                    return
                }
                for await summary in healthKitAdapter.restingHeartRateSummaryStream(days: 7) {
                    guard !Task.isCancelled else { break }
                    continuation.yield(MetricsUpdate(title: "Metrics", restingHeartRateSummary: summary))
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
