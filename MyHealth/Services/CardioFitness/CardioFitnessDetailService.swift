//
//  CardioFitnessDetailService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

public final class CardioFitnessDetailService: CardioFitnessDetailServiceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(healthKitAdapter: HealthKitAdapterProtocol) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func requestAuthorization() async -> Bool {
        await healthKitAdapter.authorizationProvider.requestCardioFitnessAuthorization()
    }

    public func updates(window: CardioFitnessWindow) -> AsyncStream<CardioFitnessDetailUpdate> {
        AsyncStream { continuation in
            let task = Task { [healthKitAdapter] in
                let range = window.dateRange(endingAt: Date())
                let readings = await healthKitAdapter.cardioFitnessReadings(from: range.start, to: range.end)
                let dayStats = await healthKitAdapter.cardioFitnessDailyStats(days: window.days)
                guard !Task.isCancelled else { return }
                continuation.yield(CardioFitnessDetailUpdate(readings: readings, dayStats: dayStats))
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
