//
//  HealthKitStandHoursAdapter.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import Models

public final class HealthKitStandHoursAdapter: HealthKitStandHoursAdapterProtocol {
    private let storeAdaptor: HealthStoreAdaptorProtocol

    public init(storeAdaptor: HealthStoreAdaptorProtocol) {
        self.storeAdaptor = storeAdaptor
    }

    public static func live() -> HealthKitStandHoursAdapter {
        HealthKitStandHoursAdapter(storeAdaptor: HealthStoreAdaptor())
    }

    public func requestAuthorization() async -> Bool {
        await storeAdaptor.authorizationProvider.requestStandHoursAuthorization()
    }

    public func standHoursSummaryStream(days: Int) -> AsyncStream<StandHoursSummary> {
        AsyncStream { continuation in
            let task = Task { [storeAdaptor] in
                let days = max(days, 1)
                let dayTotals = await storeAdaptor.fetchStandHourCounts(days: days)
                guard !Task.isCancelled else { return }
                let latest = dayTotals.first
                let previous = Array(dayTotals.dropFirst())
                continuation.yield(StandHoursSummary(latest: latest, previous: previous))
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
