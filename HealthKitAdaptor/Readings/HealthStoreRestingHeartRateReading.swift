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
        let stats = await fetchDailyDiscreteStats(
            quantityType: restingType,
            unit: unit,
            days: days
        )
        let days = stats.map { stat in
            RestingHeartRateDay(date: stat.date, averageBpm: stat.average ?? 0)
        }
        return days.sorted { $0.date > $1.date }
    }

    func fetchRestingHeartRateReadings(on date: Date) async -> [RestingHeartRateReading] {
        guard let restingType = HKQuantityType.quantityType(forIdentifier: .restingHeartRate) else { return [] }
        let window = dayWindow(for: date)
        let sortDescriptor = sortByStartDate(ascending: false)
        let samples = await fetchQuantitySamples(
            quantityType: restingType,
            predicate: window.predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]
        )
        return samples.map(RestingHeartRateReading.init(sample:))
    }
}
