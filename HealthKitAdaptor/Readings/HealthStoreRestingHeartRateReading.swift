//
//  HealthStoreRestingHeartRateReading.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

@MainActor
internal protocol HealthStoreRestingHeartRateReading {
    var healthStore: HKHealthStore { get }
}

@MainActor
extension HealthStoreRestingHeartRateReading {
    public func fetchRestingHeartRateDays(days: Int) async -> [RestingHeartRateDay] {
        guard let restingType = HKQuantityType.quantityType(forIdentifier: .restingHeartRate) else { return [] }
        let safeDays = max(days, 1)
        let calendar = Calendar.current
        let endDate = Date()
        let anchorDate = calendar.startOfDay(for: endDate)
        guard let startDate = calendar.date(byAdding: .day, value: -(safeDays - 1), to: anchorDate) else {
            return []
        }
        let interval = DateComponents(day: 1)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let unit = HKUnit.count().unitDivided(by: .minute())
        return await withCheckedContinuation { continuation in
            let query = HKStatisticsCollectionQuery(
                quantityType: restingType,
                quantitySamplePredicate: predicate,
                options: .discreteAverage,
                anchorDate: anchorDate,
                intervalComponents: interval
            )
            query.initialResultsHandler = { _, results, _ in
                var days: [RestingHeartRateDay] = []
                if let results {
                    results.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                        let average = statistics.averageQuantity()?.doubleValue(for: unit) ?? 0
                        days.append(RestingHeartRateDay(date: statistics.startDate, averageBpm: average))
                    }
                }
                let sorted = days.sorted { $0.date > $1.date }
                continuation.resume(returning: sorted)
            }
            healthStore.execute(query)
        }
    }

    public func fetchRestingHeartRateReadings(on date: Date) async -> [RestingHeartRateReading] {
        guard let restingType = HKQuantityType.quantityType(forIdentifier: .restingHeartRate) else { return [] }
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else { return [] }
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: restingType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, _ in
                let readings = (samples as? [HKQuantitySample])?.map(RestingHeartRateReading.init(sample:)) ?? []
                continuation.resume(returning: readings)
            }
            healthStore.execute(query)
        }
    }
}
