//
//  HealthKitBloodOxygenAdapter.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public final class HealthKitBloodOxygenAdapter: HealthKitBloodOxygenAdapterProtocol {
    private let storeAdaptor: HealthStoreAdaptorProtocol

    public init(storeAdaptor: HealthStoreAdaptorProtocol) {
        self.storeAdaptor = storeAdaptor
    }

    public static func live() -> HealthKitBloodOxygenAdapter {
        HealthKitBloodOxygenAdapter(storeAdaptor: HealthStoreAdaptor())
    }

    public func requestAuthorization() async -> Bool {
        await storeAdaptor.authorizationProvider.requestBloodOxygenAuthorization()
    }

    public func bloodOxygenSummaryStream() -> AsyncStream<BloodOxygenSummary> {
        AsyncStream { continuation in
            let task = Task { [storeAdaptor] in
                let readings = await storeAdaptor.fetchBloodOxygenReadings(limit: 20)
                guard !Task.isCancelled else { return }
                let latest = readings.first
                let previous = Array(readings.dropFirst())
                continuation.yield(BloodOxygenSummary(latest: latest, previous: previous))
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    public func bloodOxygenReading(id: UUID) async throws -> BloodOxygenReading {
        try await storeAdaptor.fetchBloodOxygenReading(id: id)
    }

    public func bloodOxygenReadings(start: Date, end: Date) async -> [BloodOxygenReading] {
        await storeAdaptor.fetchBloodOxygenReadings(start: start, end: end)
    }
}
