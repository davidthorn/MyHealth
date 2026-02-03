//
//  HealthKitActiveEnergyAdapter.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import Models

public final class HealthKitActiveEnergyAdapter: HealthKitActiveEnergyAdapterProtocol {
    private let storeAdaptor: HealthStoreAdaptorProtocol

    public init(storeAdaptor: HealthStoreAdaptorProtocol) {
        self.storeAdaptor = storeAdaptor
    }

    public static func live() -> HealthKitActiveEnergyAdapter {
        HealthKitActiveEnergyAdapter(storeAdaptor: HealthStoreAdaptor())
    }

    public func requestAuthorization() async -> Bool {
        await storeAdaptor.authorizationProvider.requestActiveEnergyAuthorization()
    }

    public func activeEnergySummaryStream(days: Int) -> AsyncStream<CaloriesSummary> {
        AsyncStream { continuation in
            let task = Task { [storeAdaptor] in
                let days = max(days, 1)
                let dayTotals = await storeAdaptor.fetchActiveEnergy(days: days)
                guard !Task.isCancelled else { return }
                let latest = dayTotals.first
                let previous = Array(dayTotals.dropFirst())
                continuation.yield(CaloriesSummary(latest: latest, previous: previous))
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
