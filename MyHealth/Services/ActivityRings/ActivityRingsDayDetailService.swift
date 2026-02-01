//
//  ActivityRingsDayDetailService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

@MainActor
public final class ActivityRingsDayDetailService: ActivityRingsDayDetailServiceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(healthKitAdapter: HealthKitAdapterProtocol) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func requestAuthorization() async -> Bool {
        await healthKitAdapter.authorizationProvider.requestActivitySummaryAuthorization()
    }

    public func updates(for date: Date) -> AsyncStream<ActivityRingsDayDetailUpdate> {
        AsyncStream { continuation in
            let task = Task { [healthKitAdapter] in
                let day = await healthKitAdapter.activitySummaryDay(date: date)
                guard !Task.isCancelled else { return }
                continuation.yield(ActivityRingsDayDetailUpdate(day: day))
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
