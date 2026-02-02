//
//  NutritionService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

@MainActor
public final class NutritionService: NutritionServiceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(healthKitAdapter: HealthKitAdapterProtocol) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func updates() -> AsyncStream<NutritionUpdate> {
        AsyncStream { continuation in
            let task = Task {
                guard !Task.isCancelled else {
                    continuation.finish()
                    return
                }
                let types = healthKitAdapter.nutritionTypes()
                let summary = await NutritionSummaryBuilder().windowSummary(using: healthKitAdapter, window: .today)
                continuation.yield(NutritionUpdate(types: types, summary: summary))
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    public func nutritionSummary(window: NutritionWindow) -> AsyncStream<NutritionWindowSummary?> {
        AsyncStream { continuation in
            let task = Task { [healthKitAdapter] in
                let builder = NutritionSummaryBuilder()
                let summary = await builder.windowSummary(using: healthKitAdapter, window: window)
                continuation.yield(summary)
                for await _ in healthKitAdapter.nutritionChangesStream() {
                    guard !Task.isCancelled else { break }
                    let updated = await builder.windowSummary(using: healthKitAdapter, window: window)
                    continuation.yield(updated)
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

}
