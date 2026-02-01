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
                continuation.yield(NutritionUpdate(types: healthKitAdapter.nutritionTypes()))
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
