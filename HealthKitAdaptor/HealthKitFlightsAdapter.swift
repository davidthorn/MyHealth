//
//  HealthKitFlightsAdapter.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import Models

@MainActor
public final class HealthKitFlightsAdapter: HealthKitFlightsAdapterProtocol {
    private let storeAdaptor: HealthStoreAdaptorProtocol

    public init(storeAdaptor: HealthStoreAdaptorProtocol) {
        self.storeAdaptor = storeAdaptor
    }

    public static func live() -> HealthKitFlightsAdapter {
        HealthKitFlightsAdapter(storeAdaptor: HealthStoreAdaptor())
    }

    public func requestAuthorization() async -> Bool {
        await storeAdaptor.requestFlightsAuthorization()
    }

    public func flightsSummaryStream(days: Int) -> AsyncStream<FlightsSummary> {
        AsyncStream { continuation in
            let task = Task { [storeAdaptor] in
                let days = max(days, 1)
                let dayTotals = await storeAdaptor.fetchFlightCounts(days: days)
                guard !Task.isCancelled else { return }
                let latest = dayTotals.first
                let previous = Array(dayTotals.dropFirst())
                continuation.yield(FlightsSummary(latest: latest, previous: previous))
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
