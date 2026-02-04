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

extension HealthStoreBloodOxygenReading where Self: HealthStoreSampleQuerying {
    public func fetchBloodOxygenReadings(limit: Int) async -> [BloodOxygenReading] {
        guard let oxygenType = HKQuantityType.quantityType(forIdentifier: .oxygenSaturation) else { return [] }
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let samples: [HKQuantitySample] = await fetchSamples(
            sampleType: oxygenType,
            predicate: nil,
            limit: limit,
            sortDescriptors: [sortDescriptor]
        )
        return samples.map(BloodOxygenReading.init)
    }

    public func fetchBloodOxygenReading(id: UUID) async throws -> BloodOxygenReading {
        guard let oxygenType = HKQuantityType.quantityType(forIdentifier: .oxygenSaturation) else {
            throw HealthKitAdapterError.bloodOxygenReadingNotFound
        }
        let predicate = HKQuery.predicateForObject(with: id)
        let sample: HKQuantitySample = try await fetchSample(
            sampleType: oxygenType,
            predicate: predicate,
            errorOnMissing: HealthKitAdapterError.bloodOxygenReadingNotFound
        )
        return BloodOxygenReading(sample: sample)
    }

    public func fetchBloodOxygenReadings(start: Date, end: Date) async -> [BloodOxygenReading] {
        guard let oxygenType = HKQuantityType.quantityType(forIdentifier: .oxygenSaturation) else { return [] }
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        let samples: [HKQuantitySample] = await fetchSamples(
            sampleType: oxygenType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]
        )
        return samples.map(BloodOxygenReading.init)
    }
}
