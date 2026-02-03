//
//  HealthStoreNutritionWriting.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

internal protocol HealthStoreNutritionWriting {
    var healthStore: HKHealthStore { get }
    func notifyNutritionChanged()
}

extension HealthStoreNutritionWriting {
    public func saveNutritionSample(_ sample: NutritionSample) async throws {
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

    public func deleteNutritionSample(id: UUID, type: NutritionType) async throws {
        guard let identifier = type.quantityIdentifier,
              let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            throw HealthKitAdapterError.unsupportedNutritionType
        }
        let sample = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<HKQuantitySample, Error>) in
            let predicate = HKQuery.predicateForObject(with: id)
            let query = HKSampleQuery(
                sampleType: quantityType,
                predicate: predicate,
                limit: 1,
                sortDescriptors: nil
            ) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let sample = (samples as? [HKQuantitySample])?.first else {
                    continuation.resume(throwing: HealthKitAdapterError.nutritionSampleNotFound)
                    return
                }
                continuation.resume(returning: sample)
            }
            healthStore.execute(query)
        }
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
