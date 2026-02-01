//
//  NutritionTypeListService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

@MainActor
public final class NutritionTypeListService: NutritionTypeListServiceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(
        healthKitAdapter: HealthKitAdapterProtocol
    ) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func updates(for type: NutritionType) -> AsyncStream<NutritionTypeListUpdate> {
        AsyncStream { continuation in
            let task = Task { [weak self] in
                guard let self else { return }
                await self.fetchAndYield(type: type, continuation: continuation)
            }
            let refreshTask = Task { [weak self] in
                guard let self else { return }
                for await _ in healthKitAdapter.nutritionChangesStream() {
                    guard !Task.isCancelled else { break }
                    await self.fetchAndYield(type: type, continuation: continuation)
                }
            }
            continuation.onTermination = { _ in
                task.cancel()
                refreshTask.cancel()
            }
        }
    }

    public func requestAuthorization(type: NutritionType) async -> Bool {
        let isAuthorized = await healthKitAdapter.authorizationProvider.requestNutritionReadAuthorization(type: type)
        return isAuthorized
    }

    private func fetchAndYield(type: NutritionType, continuation: AsyncStream<NutritionTypeListUpdate>.Continuation) async {
        let samples = await healthKitAdapter.nutritionSamples(type: type, limit: 0)
        let sorted = samples.sorted { $0.date > $1.date }
        continuation.yield(NutritionTypeListUpdate(type: type, samples: sorted))
    }
}
