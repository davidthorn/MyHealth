//
//  HealthStoreNutritionWriting.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

public protocol HealthStoreNutritionWriting: HealthStoreSampleQuerying {
    func notifyNutritionChanged()
}

public extension HealthStoreNutritionWriting {
    func saveNutritionSample(_ sample: NutritionSample) async throws {
        guard let identifier = sample.type.quantityIdentifier,
              let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            throw HealthKitAdapterError.unsupportedNutritionType
        }
        let unit = sample.type.quantityUnit
        let quantity = HKQuantity(unit: unit, doubleValue: sample.value)
        let hkSample = HKQuantitySample(
            type: quantityType,
            quantity: quantity,
            start: sample.date,
            end: sample.date
        )
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            healthStore.save(hkSample) { success, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                if success {
                    continuation.resume(returning: ())
                } else {
                    continuation.resume(throwing: HealthKitAdapterError.deleteFailed)
                }
            }
        }
        notifyNutritionChanged()
    }

    func deleteNutritionSample(id: UUID, type: NutritionType) async throws {
        guard let identifier = type.quantityIdentifier,
              let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            throw HealthKitAdapterError.unsupportedNutritionType
        }
        let sample: HKQuantitySample = try await fetchSample(
            sampleType: quantityType,
            id: id,
            errorOnMissing: HealthKitAdapterError.nutritionSampleNotFound
        )
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            healthStore.delete([sample]) { success, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                if success {
                    continuation.resume(returning: ())
                } else {
                    continuation.resume(throwing: HealthKitAdapterError.deleteFailed)
                }
            }
        }
        notifyNutritionChanged()
    }
}
