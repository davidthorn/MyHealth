//
//  HealthKitActivitySummaryAdapter.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import Models

public final class HealthKitActivitySummaryAdapter: HealthKitActivitySummaryAdapterProtocol {
    private let storeAdaptor: HealthStoreAdaptorProtocol

    public init(storeAdaptor: HealthStoreAdaptorProtocol) {
        self.storeAdaptor = storeAdaptor
    }

    public static func live() -> HealthKitActivitySummaryAdapter {
        HealthKitActivitySummaryAdapter(storeAdaptor: HealthStoreAdaptor())
    }

    public func requestAuthorization() async -> Bool {
        await storeAdaptor.authorizationProvider.requestActivitySummaryAuthorization()
    }

    public func activitySummaryStream(days: Int) -> AsyncStream<ActivityRingsSummary> {
        AsyncStream { continuation in
            let task = Task { [storeAdaptor] in
                let safeDays = max(days, 1)
                let dayTotals = await storeAdaptor.fetchActivitySummaries(days: safeDays)
                guard !Task.isCancelled else { return }
                let latest = dayTotals.first
                let previous = Array(dayTotals.dropFirst())
                continuation.yield(ActivityRingsSummary(latest: latest, previous: previous))
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    public func activitySummaryDay(date: Date) async -> ActivityRingsDay {
        await storeAdaptor.fetchActivitySummaryDay(date: date)
    }
}
