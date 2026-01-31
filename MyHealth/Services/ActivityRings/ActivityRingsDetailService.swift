//
//  ActivityRingsDetailService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

@MainActor
public final class ActivityRingsDetailService: ActivityRingsDetailServiceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(healthKitAdapter: HealthKitAdapterProtocol) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func requestAuthorization() async -> Bool {
        await healthKitAdapter.requestActivitySummaryAuthorization()
    }

    public func updates() -> AsyncStream<ActivityRingsDetailUpdate> {
        AsyncStream { continuation in
            let task = Task { [healthKitAdapter] in
                for await summary in healthKitAdapter.activitySummaryStream(days: 30) {
                    guard !Task.isCancelled else { return }
                    continuation.yield(ActivityRingsDetailUpdate(summary: summary))
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
