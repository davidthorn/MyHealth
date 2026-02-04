//
//  HealthKitCardioFitnessAdapter.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public final class HealthKitCardioFitnessAdapter: HealthKitCardioFitnessAdapterProtocol {
    private let storeAdaptor: HealthStoreAdaptorProtocol

    public init(storeAdaptor: HealthStoreAdaptorProtocol) {
        self.storeAdaptor = storeAdaptor
    }

    public static func live() -> HealthKitCardioFitnessAdapter {
        HealthKitCardioFitnessAdapter(storeAdaptor: HealthStoreAdaptor())
    }

    public func requestAuthorization() async -> Bool {
        await storeAdaptor.authorizationProvider.requestCardioFitnessAuthorization()
    }

    public func cardioFitnessSummaryStream() -> AsyncStream<CardioFitnessSummary> {
        AsyncStream { continuation in
            let task = Task { [storeAdaptor] in
                let readings = await storeAdaptor.fetchCardioFitnessReadings(limit: 20)
                guard !Task.isCancelled else { return }
                let latest = readings.first
                let previous = Array(readings.dropFirst())
                continuation.yield(CardioFitnessSummary(latest: latest, previous: previous))
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    public func cardioFitnessReading(id: UUID) async throws -> CardioFitnessReading {
        try await storeAdaptor.fetchCardioFitnessReading(id: id)
    }

    public func cardioFitnessReadings(start: Date, end: Date) async -> [CardioFitnessReading] {
        await storeAdaptor.fetchCardioFitnessReadings(start: start, end: end)
    }

    public func cardioFitnessDailyStats(days: Int) async -> [CardioFitnessDayStats] {
        await storeAdaptor.fetchCardioFitnessDailyStats(days: days)
    }
}
