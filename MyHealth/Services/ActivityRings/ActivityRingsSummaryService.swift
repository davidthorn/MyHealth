//
//  ActivityRingsSummaryService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

@MainActor
public final class ActivityRingsSummaryService: ActivityRingsSummaryServiceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(healthKitAdapter: HealthKitAdapterProtocol) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func requestAuthorization() async -> Bool {
        await healthKitAdapter.authorizationProvider.requestActivitySummaryAuthorization()
    }

    public func updates() -> AsyncStream<ActivityRingsSummaryUpdate> {
        AsyncStream { continuation in
            let task = Task { [healthKitAdapter] in
                for await summary in healthKitAdapter.activitySummaryStream(days: 14) {
                    guard !Task.isCancelled else { return }
                    continuation.yield(ActivityRingsSummaryUpdate(summary: summary))
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
