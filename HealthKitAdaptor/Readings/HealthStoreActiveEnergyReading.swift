//
//  HealthStoreActiveEnergyReading.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

internal protocol HealthStoreActiveEnergyReading {
    var healthStore: HKHealthStore { get }
}

extension HealthStoreActiveEnergyReading {
    public func fetchActiveEnergy(days: Int) async -> [CaloriesDay] {
        guard let activeType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else { return [] }
        let safeDays = max(days, 1)
        let calendar = Calendar.current
        let endDate = Date()
        let anchorDate = calendar.startOfDay(for: endDate)
        guard let startDate = calendar.date(byAdding: .day, value: -(safeDays - 1), to: anchorDate) else {
            return []
        }
        let interval = DateComponents(day: 1)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        return await withCheckedContinuation { continuation in
            let query = HKStatisticsCollectionQuery(
                quantityType: activeType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum,
                anchorDate: anchorDate,
                intervalComponents: interval
            )
            query.initialResultsHandler = { _, results, _ in
                var days: [CaloriesDay] = []
                if let results {
                    results.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                        let kcal = statistics.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
                        days.append(CaloriesDay(date: statistics.startDate, activeKilocalories: kcal))
                    }
                }
                let sorted = days.sorted { $0.date > $1.date }
                continuation.resume(returning: sorted)
            }
            healthStore.execute(query)
        }
    }
}
