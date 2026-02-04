//
//  HealthStoreNutritionReading.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

public protocol HealthStoreNutritionReading {
    var healthStore: HKHealthStore { get }
}

public extension HealthStoreNutritionReading where Self: HealthStoreSampleQuerying {
    func fetchNutritionSamples(type: NutritionType, limit: Int) async -> [NutritionSample] {
        guard let identifier = type.quantityIdentifier,
              let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            return []
        }
        let sortDescriptor = sortByEndDate(ascending: false)
        let queryLimit = limit > 0 ? limit : HKObjectQueryNoLimit
        let unit = type.quantityUnit
        let unitLabel = type.unit
        let sampleType = type
        let samples = await fetchQuantitySamples(
            quantityType: quantityType,
            predicate: nil,
            limit: queryLimit,
            sortDescriptors: [sortDescriptor]
        )
        return samples.map { sample in
            NutritionSample(
                id: sample.uuid,
                type: sampleType,
                date: sample.endDate,
                value: sample.quantity.doubleValue(for: unit),
                unit: unitLabel
            )
        }
    }

    func fetchNutritionSamples(type: NutritionType, start: Date, end: Date) async -> [NutritionSample] {
        guard let identifier = type.quantityIdentifier,
              let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            return []
        }
        let predicate = rangePredicate(start: start, end: end)
        let sortDescriptor = sortByEndDate(ascending: false)
        let unit = type.quantityUnit
        let unitLabel = type.unit
        let sampleType = type
        let samples = await fetchQuantitySamples(
            quantityType: quantityType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]
        )
        return samples.map { sample in
            NutritionSample(
                id: sample.uuid,
                type: sampleType,
                date: sample.endDate,
                value: sample.quantity.doubleValue(for: unit),
                unit: unitLabel
            )
        }
    }

    func fetchNutritionTotal(type: NutritionType, start: Date, end: Date) async -> Double? {
        guard let identifier = type.quantityIdentifier,
              let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            return nil
        }
        let predicate = rangePredicate(start: start, end: end)
        let unit = type.quantityUnit
        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: quantityType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, statistics, _ in
                let total = statistics?.sumQuantity()?.doubleValue(for: unit)
                continuation.resume(returning: total)
            }
            healthStore.execute(query)
        }
    }
}
