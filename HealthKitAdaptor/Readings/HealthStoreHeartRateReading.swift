//
//  HealthStoreHeartRateReading.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

internal protocol HealthStoreHeartRateReading {
    var healthStore: HKHealthStore { get }
}

extension HealthStoreHeartRateReading {
    public func fetchHeartRateReadings(limit: Int) async -> [HeartRateReading] {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return [] }
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: heartRateType,
                predicate: nil,
                limit: limit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, _ in
                let readings: [HeartRateReading] = (samples as? [HKQuantitySample])?.map(HeartRateReading.init) ?? []
                continuation.resume(returning: readings)
            }
            healthStore.execute(query)
        }
    }

    public func fetchHeartRateReading(id: UUID) async throws -> HeartRateReading {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            throw HealthKitAdapterError.heartRateReadingNotFound
        }
        return try await withCheckedThrowingContinuation { continuation in
            let predicate = HKQuery.predicateForObject(with: id)
            let query = HKSampleQuery(
                sampleType: heartRateType,
                predicate: predicate,
                limit: 1,
                sortDescriptors: nil
            ) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let sample = (samples as? [HKQuantitySample])?.first else {
                    continuation.resume(throwing: HealthKitAdapterError.heartRateReadingNotFound)
                    return
                }
                let reading = HeartRateReading(sample: sample)
                continuation.resume(returning: reading)
            }
            healthStore.execute(query)
        }
    }

    public func fetchHeartRateReadings(start: Date, end: Date) async -> [HeartRateReading] {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return [] }
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: heartRateType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, _ in
                let readings: [HeartRateReading] = (samples as? [HKQuantitySample])?.map(HeartRateReading.init) ?? []
                continuation.resume(returning: readings)
            }
            healthStore.execute(query)
        }
    }
}
