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
        let sortDescriptor = sortByEndDate(ascending: false)
        let samples = await fetchQuantitySamples(
            quantityType: hrvType,
            predicate: nil,
            limit: limit,
            sortDescriptors: [sortDescriptor]
        )
        return samples.map(HeartRateVariabilityReading.init)
    }

    func fetchHeartRateVariabilityDailyStats(days: Int) async -> [HeartRateVariabilityDayStats] {
        guard let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else { return [] }
        let unit = HKUnit.secondUnit(with: .milli)
        let stats = await fetchDailyDiscreteStats(
            quantityType: hrvType,
            unit: unit,
            days: days
        )
        return stats.map {
            HeartRateVariabilityDayStats(
                date: $0.date,
                averageMilliseconds: $0.average,
                minMilliseconds: $0.minimum,
                maxMilliseconds: $0.maximum
            )
        }
    }

    func fetchHeartRateVariabilityReading(id: UUID) async throws -> HeartRateVariabilityReading {
        guard let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else {
            throw HealthKitAdapterError.heartRateVariabilityReadingNotFound
        }
        let sample: HKQuantitySample = try await fetchSample(
            sampleType: hrvType,
            id: id,
            errorOnMissing: HealthKitAdapterError.heartRateVariabilityReadingNotFound
        )
        return HeartRateVariabilityReading(sample: sample)
    }

    func fetchHeartRateVariabilityReadings(start: Date, end: Date) async -> [HeartRateVariabilityReading] {
        guard let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else { return [] }
        let predicate = rangePredicate(start: start, end: end)
        let sortDescriptor = sortByEndDate(ascending: true)
        let samples = await fetchQuantitySamples(
            quantityType: hrvType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]
        )
        return samples.map(HeartRateVariabilityReading.init)
    }
}
