//
//  HealthStoreBloodOxygenReading.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

internal protocol HealthStoreBloodOxygenReading {
    var healthStore: HKHealthStore { get }
}

extension HealthStoreBloodOxygenReading {
    public func fetchBloodOxygenReadings(limit: Int) async -> [BloodOxygenReading] {
        guard let oxygenType = HKQuantityType.quantityType(forIdentifier: .oxygenSaturation) else { return [] }
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: oxygenType,
                predicate: nil,
                limit: limit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, _ in
                let readings: [BloodOxygenReading] = (samples as? [HKQuantitySample])?.map(BloodOxygenReading.init) ?? []
                continuation.resume(returning: readings)
            }
            healthStore.execute(query)
        }
    }

    public func fetchBloodOxygenReading(id: UUID) async throws -> BloodOxygenReading {
        guard let oxygenType = HKQuantityType.quantityType(forIdentifier: .oxygenSaturation) else {
            throw HealthKitAdapterError.bloodOxygenReadingNotFound
        }
        return try await withCheckedThrowingContinuation { continuation in
            let predicate = HKQuery.predicateForObject(with: id)
            let query = HKSampleQuery(
                sampleType: oxygenType,
                predicate: predicate,
                limit: 1,
                sortDescriptors: nil
            ) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let sample = (samples as? [HKQuantitySample])?.first else {
                    continuation.resume(throwing: HealthKitAdapterError.bloodOxygenReadingNotFound)
                    return
                }
                continuation.resume(returning: BloodOxygenReading(sample: sample))
            }
            healthStore.execute(query)
        }
    }

    public func fetchBloodOxygenReadings(start: Date, end: Date) async -> [BloodOxygenReading] {
        guard let oxygenType = HKQuantityType.quantityType(forIdentifier: .oxygenSaturation) else { return [] }
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: oxygenType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, _ in
                let readings: [BloodOxygenReading] = (samples as? [HKQuantitySample])?.map(BloodOxygenReading.init) ?? []
                continuation.resume(returning: readings)
            }
            healthStore.execute(query)
        }
    }
}
