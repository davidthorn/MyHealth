//
//  HydrationService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

public final class HydrationService: HydrationOverviewServiceProtocol, HydrationEntryServiceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(healthKitAdapter: HealthKitAdapterProtocol) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func requestReadAuthorization() async -> Bool {
        await healthKitAdapter.authorizationProvider.requestNutritionReadAuthorization(type: .water)
    }

    public func requestWriteAuthorization() async -> Bool {
        await healthKitAdapter.authorizationProvider.requestNutritionWriteAuthorization(type: .water)
    }

    public func updates(window: HydrationWindow) -> AsyncStream<HydrationOverviewUpdate> {
        AsyncStream { continuation in
            let task = Task { [healthKitAdapter] in
                let calendar = Calendar.current
                let todayStart = calendar.startOfDay(for: Date())
                let todayEnd = calendar.date(byAdding: .day, value: 1, to: todayStart) ?? Date()
                let todayTotal = await healthKitAdapter.nutritionTotal(type: .water, start: todayStart, end: todayEnd)

                let range = window.dateRange(endingAt: Date())
                let windowTotal = await healthKitAdapter.nutritionTotal(type: .water, start: range.start, end: range.end)
                let samples = await healthKitAdapter.nutritionSamples(type: .water, start: range.start, end: range.end)
                guard !Task.isCancelled else { return }
                continuation.yield(
                    HydrationOverviewUpdate(
                        window: window,
                        samples: samples.sorted { $0.date > $1.date },
                        todayTotalMilliliters: todayTotal,
                        windowTotalMilliliters: windowTotal
                    )
                )
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    public func saveHydration(amountMilliliters: Double, date: Date) async throws {
        let sample = NutritionSample(
            type: .water,
            date: date,
            value: amountMilliliters,
            unit: NutritionType.water.unit
        )
        try await healthKitAdapter.saveNutritionSample(sample)
    }
}
