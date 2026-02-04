//
//  HealthStoreHeartRateReading.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

public protocol HealthStoreHeartRateReading {
    var healthStore: HKHealthStore { get }
}

public extension HealthStoreHeartRateReading where Self: HealthStoreSampleQuerying {
    func fetchHeartRateReadings(limit: Int) async -> [HeartRateReading] {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return [] }
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let samples = await fetchQuantitySamples(
            quantityType: heartRateType,
            predicate: nil,
            limit: limit,
            sortDescriptors: [sortDescriptor]
        )
        return samples.map(HeartRateReading.init)
    }

    func fetchHeartRateReading(id: UUID) async throws -> HeartRateReading {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            throw HealthKitAdapterError.heartRateReadingNotFound
        }
        let sample: HKQuantitySample = try await fetchSample(
            sampleType: heartRateType,
            id: id,
            errorOnMissing: HealthKitAdapterError.heartRateReadingNotFound
        )
        return HeartRateReading(sample: sample)
    }

    func fetchHeartRateReadings(start: Date, end: Date) async -> [HeartRateReading] {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return [] }
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        let samples = await fetchQuantitySamples(
            quantityType: heartRateType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]
        )
        return samples.map(HeartRateReading.init)
    }
}
