//
//  HealthKitStepsAdapter.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import Models

public final class HealthKitStepsAdapter: HealthKitStepsAdapterProtocol {
    private let storeAdaptor: HealthStoreAdaptorProtocol

    public init(storeAdaptor: HealthStoreAdaptorProtocol) {
        self.storeAdaptor = storeAdaptor
    }

    public static func live() -> HealthKitStepsAdapter {
        HealthKitStepsAdapter(storeAdaptor: HealthStoreAdaptor())
    }

    public func requestAuthorization() async -> Bool {
        await storeAdaptor.authorizationProvider.requestStepsAuthorization()
    }

    public func stepsSummaryStream(days: Int) -> AsyncStream<StepsSummary> {
        AsyncStream { continuation in
            let task = Task { [storeAdaptor] in
                let days = max(days, 1)
                let dayTotals = await storeAdaptor.fetchStepCounts(days: days)
                guard !Task.isCancelled else { return }
                let latest = dayTotals.first
                let previous = Array(dayTotals.dropFirst())
                continuation.yield(StepsSummary(latest: latest, previous: previous))
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
