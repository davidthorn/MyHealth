//
//  NutritionEntryDetailService.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

@MainActor
public final class NutritionEntryDetailService: NutritionEntryDetailServiceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(
        healthKitAdapter: HealthKitAdapterProtocol
    ) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func updates(for sample: NutritionSample) -> AsyncStream<NutritionEntryDetailUpdate> {
        AsyncStream { continuation in
            let task = Task {
                guard !Task.isCancelled else {
                    continuation.finish()
                    return
                }
                continuation.yield(NutritionEntryDetailUpdate(sample: sample))
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    public func save(sample: NutritionSample) async throws {
        let isAuthorized = await healthKitAdapter.authorizationProvider.requestNutritionWriteAuthorization(type: sample.type)
        guard isAuthorized else { return }
        try await healthKitAdapter.saveNutritionSample(sample)
    }

    public func update(original: NutritionSample, updated: NutritionSample) async throws {
        let isAuthorized = await healthKitAdapter.authorizationProvider.requestNutritionWriteAuthorization(type: updated.type)
        guard isAuthorized else { return }
        try await healthKitAdapter.deleteNutritionSample(id: original.id, type: original.type)
        try await healthKitAdapter.saveNutritionSample(updated)
    }

    public func delete(sample: NutritionSample) async throws {
        let isAuthorized = await healthKitAdapter.authorizationProvider.requestNutritionWriteAuthorization(type: sample.type)
        guard isAuthorized else { return }
        try await healthKitAdapter.deleteNutritionSample(id: sample.id, type: sample.type)
    }
}
