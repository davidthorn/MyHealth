//
//  BloodOxygenDetailService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

public final class BloodOxygenDetailService: BloodOxygenDetailServiceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(healthKitAdapter: HealthKitAdapterProtocol) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func requestAuthorization() async -> Bool {
        await healthKitAdapter.authorizationProvider.requestBloodOxygenAuthorization()
    }

    public func updates(window: BloodOxygenWindow) -> AsyncStream<BloodOxygenDetailUpdate> {
        AsyncStream { continuation in
            let task = Task { [healthKitAdapter] in
                let range = window.dateRange(endingAt: Date())
                let readings = await healthKitAdapter.bloodOxygenReadings(from: range.start, to: range.end)
                guard !Task.isCancelled else { return }
                continuation.yield(BloodOxygenDetailUpdate(readings: readings))
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
