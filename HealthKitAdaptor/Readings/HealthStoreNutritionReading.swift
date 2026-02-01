//
//  HealthStoreNutritionReading.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

@MainActor
internal protocol HealthStoreNutritionReading {
    var healthStore: HKHealthStore { get }
}

@MainActor
extension HealthStoreNutritionReading {
    public func fetchNutritionSamples(type: NutritionType, limit: Int) async -> [NutritionSample] {
        guard let identifier = type.quantityIdentifier,
              let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            return []
        }
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let queryLimit = limit > 0 ? limit : HKObjectQueryNoLimit
        let unit = type.quantityUnit
        let unitLabel = type.unit
        let sampleType = type
        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: quantityType,
                predicate: nil,
                limit: queryLimit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, _ in
                let items: [NutritionSample] = (samples as? [HKQuantitySample])?.map { sample in
                    NutritionSample(
                        id: sample.uuid,
                        type: sampleType,
                        date: sample.endDate,
                        value: sample.quantity.doubleValue(for: unit),
                        unit: unitLabel
                    )
                } ?? []
                continuation.resume(returning: items)
            }
            healthStore.execute(query)
        }
    }

    public func fetchNutritionSamples(type: NutritionType, start: Date, end: Date) async -> [NutritionSample] {
        guard let identifier = type.quantityIdentifier,
              let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            return []
        }
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let unit = type.quantityUnit
        let unitLabel = type.unit
        let sampleType = type
        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: quantityType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, _ in
                let items: [NutritionSample] = (samples as? [HKQuantitySample])?.map { sample in
                    NutritionSample(
                        id: sample.uuid,
                        type: sampleType,
                        date: sample.endDate,
                        value: sample.quantity.doubleValue(for: unit),
                        unit: unitLabel
                    )
                } ?? []
                continuation.resume(returning: items)
            }
            healthStore.execute(query)
        }
    }
}
