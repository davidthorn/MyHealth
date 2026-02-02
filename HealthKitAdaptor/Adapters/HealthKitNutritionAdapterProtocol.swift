//
//  HealthKitNutritionAdapterProtocol.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import Models

public protocol HealthKitNutritionAdapterProtocol {
    func requestReadAuthorization(type: NutritionType) async -> Bool
    func requestWriteAuthorization(type: NutritionType) async -> Bool
    func nutritionTypes() -> [NutritionType]
    func nutritionSamples(type: NutritionType, limit: Int) async -> [NutritionSample]
    func nutritionSamples(type: NutritionType, start: Date, end: Date) async -> [NutritionSample]
    func nutritionTotal(type: NutritionType, start: Date, end: Date) async -> Double?
    func saveNutritionSample(_ sample: NutritionSample) async throws
    func deleteNutritionSample(id: UUID, type: NutritionType) async throws
    func nutritionChangesStream() -> AsyncStream<Void>
}
