//
//  HealthStoreRestingHeartRateReading.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

public protocol HealthStoreRestingHeartRateReading {
    var healthStore: HKHealthStore { get }
}

public extension HealthStoreRestingHeartRateReading where Self: HealthStoreSampleQuerying {
    func fetchRestingHeartRateDays(days: Int) async -> [RestingHeartRateDay] {
        guard let restingType = HKQuantityType.quantityType(forIdentifier: .restingHeartRate) else { return [] }
        let unit = HKUnit.count().unitDivided(by: .minute())
        let days = await fetchDailyDiscreteStats(
            quantityType: restingType,
            unit: unit,
            days: days
        ) { date, avg, _, _ in
            RestingHeartRateDay(date: date, averageBpm: avg ?? 0)
        }
        return days.sorted { $0.date > $1.date }
    }

    func fetchRestingHeartRateReadings(on date: Date) async -> [RestingHeartRateReading] {
        guard let restingType = HKQuantityType.quantityType(forIdentifier: .restingHeartRate) else { return [] }
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else { return [] }
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let samples = await fetchQuantitySamples(
            quantityType: restingType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]
        )
        return samples.map(RestingHeartRateReading.init(sample:))
    }
}
