//
//  HealthKitNutritionAdapter.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import Models

@MainActor
public final class HealthKitNutritionAdapter: HealthKitNutritionAdapterProtocol {
    private let storeAdaptor: HealthStoreAdaptorProtocol

    public init(storeAdaptor: HealthStoreAdaptorProtocol) {
        self.storeAdaptor = storeAdaptor
    }

    public static func live() -> HealthKitNutritionAdapter {
        HealthKitNutritionAdapter(storeAdaptor: HealthStoreAdaptor())
    }

    public func requestReadAuthorization(type: NutritionType) async -> Bool {
        await storeAdaptor.authorizationProvider.requestNutritionReadAuthorization(type: type)
    }

    public func requestWriteAuthorization(type: NutritionType) async -> Bool {
        await storeAdaptor.authorizationProvider.requestNutritionWriteAuthorization(type: type)
    }

    public func nutritionTypes() -> [NutritionType] {
        NutritionType.allCases
    }

    public func nutritionSamples(type: NutritionType, limit: Int) async -> [NutritionSample] {
        await storeAdaptor.fetchNutritionSamples(type: type, limit: limit)
    }

    public func nutritionSamples(type: NutritionType, start: Date, end: Date) async -> [NutritionSample] {
        await storeAdaptor.fetchNutritionSamples(type: type, start: start, end: end)
    }

    public func saveNutritionSample(_ sample: NutritionSample) async throws {
        try await storeAdaptor.saveNutritionSample(sample)
    }

    public func deleteNutritionSample(id: UUID, type: NutritionType) async throws {
        try await storeAdaptor.deleteNutritionSample(id: id, type: type)
    }

    public func nutritionChangesStream() -> AsyncStream<Void> {
        storeAdaptor.nutritionChangesStream()
    }
}
