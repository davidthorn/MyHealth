//
//  HealthStoreHeartRateVariabilityReading.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

public protocol HealthStoreHeartRateVariabilityReading {
    var healthStore: HKHealthStore { get }
}

public extension HealthStoreHeartRateVariabilityReading where Self: HealthStoreSampleQuerying {
    func fetchHeartRateVariabilityReadings(limit: Int) async -> [HeartRateVariabilityReading] {
        guard let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else { return [] }
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let samples: [HKQuantitySample] = await fetchSamples(
            sampleType: hrvType,
            predicate: nil,
            limit: limit,
            sortDescriptors: [sortDescriptor]
        )
        return samples.map(HeartRateVariabilityReading.init)
    }

    func fetchHeartRateVariabilityDailyStats(days: Int) async -> [HeartRateVariabilityDayStats] {
        guard let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else { return [] }
        let unit = HKUnit.secondUnit(with: .milli)
        return await fetchDailyDiscreteStats(
            quantityType: hrvType,
            unit: unit,
            days: days
        ) { date, avg, min, max in
            HeartRateVariabilityDayStats(
                date: date,
                averageMilliseconds: avg,
                minMilliseconds: min,
                maxMilliseconds: max
            )
        }
    }

    func fetchHeartRateVariabilityReading(id: UUID) async throws -> HeartRateVariabilityReading {
        guard let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else {
            throw HealthKitAdapterError.heartRateVariabilityReadingNotFound
        }
        let predicate = HKQuery.predicateForObject(with: id)
        let sample: HKQuantitySample = try await fetchSample(
            sampleType: hrvType,
            predicate: predicate,
            errorOnMissing: HealthKitAdapterError.heartRateVariabilityReadingNotFound
        )
        return HeartRateVariabilityReading(sample: sample)
    }

    func fetchHeartRateVariabilityReadings(start: Date, end: Date) async -> [HeartRateVariabilityReading] {
        guard let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else { return [] }
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        let samples: [HKQuantitySample] = await fetchSamples(
            sampleType: hrvType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]
        )
        return samples.map(HeartRateVariabilityReading.init)
    }
}
