//
//  HealthStoreBloodOxygenReading.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

public protocol HealthStoreBloodOxygenReading {
    var healthStore: HKHealthStore { get }
}

public extension HealthStoreBloodOxygenReading where Self: HealthStoreSampleQuerying {
    func fetchBloodOxygenReadings(limit: Int) async -> [BloodOxygenReading] {
        guard let oxygenType = HKQuantityType.quantityType(forIdentifier: .oxygenSaturation) else { return [] }
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let samples = await fetchQuantitySamples(
            quantityType: oxygenType,
            predicate: nil,
            limit: limit,
            sortDescriptors: [sortDescriptor]
        )
        return samples.map(BloodOxygenReading.init)
    }

    func fetchBloodOxygenReading(id: UUID) async throws -> BloodOxygenReading {
        guard let oxygenType = HKQuantityType.quantityType(forIdentifier: .oxygenSaturation) else {
            throw HealthKitAdapterError.bloodOxygenReadingNotFound
        }
        let sample: HKQuantitySample = try await fetchSample(
            sampleType: oxygenType,
            id: id,
            errorOnMissing: HealthKitAdapterError.bloodOxygenReadingNotFound
        )
        return BloodOxygenReading(sample: sample)
    }

    func fetchBloodOxygenReadings(start: Date, end: Date) async -> [BloodOxygenReading] {
        guard let oxygenType = HKQuantityType.quantityType(forIdentifier: .oxygenSaturation) else { return [] }
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        let samples = await fetchQuantitySamples(
            quantityType: oxygenType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]
        )
        return samples.map(BloodOxygenReading.init)
    }
}
