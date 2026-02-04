//
//  HealthStoreHeartRateVariabilityReading.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

internal protocol HealthStoreHeartRateVariabilityReading {
    var healthStore: HKHealthStore { get }
}

extension HealthStoreHeartRateVariabilityReading {
    public func fetchHeartRateVariabilityReadings(limit: Int) async -> [HeartRateVariabilityReading] {
        guard let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else { return [] }
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: hrvType,
                predicate: nil,
                limit: limit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, _ in
                let readings: [HeartRateVariabilityReading] = (samples as? [HKQuantitySample])?.map(HeartRateVariabilityReading.init) ?? []
                continuation.resume(returning: readings)
            }
            healthStore.execute(query)
        }
    }

    public func fetchHeartRateVariabilityDailyStats(days: Int) async -> [HeartRateVariabilityDayStats] {
        guard let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else { return [] }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let startDate = calendar.date(byAdding: .day, value: -(days - 1), to: today) ?? today

        return await withCheckedContinuation { continuation in
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: today, options: .strictStartDate)
            let interval = DateComponents(day: 1)
            let query = HKStatisticsCollectionQuery(
                quantityType: hrvType,
                quantitySamplePredicate: predicate,
                options: [.discreteAverage, .discreteMin, .discreteMax],
                anchorDate: today,
                intervalComponents: interval
            )
            query.initialResultsHandler = { _, collection, _ in
                guard let collection else {
                    continuation.resume(returning: [])
                    return
                }
                var days: [HeartRateVariabilityDayStats] = []
                let unit = HKUnit.secondUnit(with: .milli)
                collection.enumerateStatistics(from: startDate, to: today) { statistics, _ in
                    let avg = statistics.averageQuantity()?.doubleValue(for: unit)
                    let min = statistics.minimumQuantity()?.doubleValue(for: unit)
                    let max = statistics.maximumQuantity()?.doubleValue(for: unit)
                    days.append(
                        HeartRateVariabilityDayStats(
                            date: statistics.startDate,
                            averageMilliseconds: avg,
                            minMilliseconds: min,
                            maxMilliseconds: max
                        )
                    )
                }
                continuation.resume(returning: days)
            }
            healthStore.execute(query)
        }
    }

    public func fetchHeartRateVariabilityReading(id: UUID) async throws -> HeartRateVariabilityReading {
        guard let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else {
            throw HealthKitAdapterError.heartRateVariabilityReadingNotFound
        }
        return try await withCheckedThrowingContinuation { continuation in
            let predicate = HKQuery.predicateForObject(with: id)
            let query = HKSampleQuery(
                sampleType: hrvType,
                predicate: predicate,
                limit: 1,
                sortDescriptors: nil
            ) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let sample = (samples as? [HKQuantitySample])?.first else {
                    continuation.resume(throwing: HealthKitAdapterError.heartRateVariabilityReadingNotFound)
                    return
                }
                continuation.resume(returning: HeartRateVariabilityReading(sample: sample))
            }
            healthStore.execute(query)
        }
    }

    public func fetchHeartRateVariabilityReadings(start: Date, end: Date) async -> [HeartRateVariabilityReading] {
        guard let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else { return [] }
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: hrvType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, _ in
                let readings: [HeartRateVariabilityReading] = (samples as? [HKQuantitySample])?.map(HeartRateVariabilityReading.init) ?? []
                continuation.resume(returning: readings)
            }
            healthStore.execute(query)
        }
    }
}
