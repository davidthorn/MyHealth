//
//  HealthStoreStepsReading.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

internal protocol HealthStoreStepsReading {
    var healthStore: HKHealthStore { get }
}

extension HealthStoreStepsReading {
    public func fetchStepCounts(days: Int) async -> [StepsDay] {
        guard let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return [] }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let startDate = calendar.date(byAdding: .day, value: -(days - 1), to: today) ?? today

        return await withCheckedContinuation { continuation in
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: today, options: .strictStartDate)
            let interval = DateComponents(day: 1)
            let query = HKStatisticsCollectionQuery(
                quantityType: stepsType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum,
                anchorDate: today,
                intervalComponents: interval
            )
            query.initialResultsHandler = { _, collection, _ in
                guard let collection else {
                    continuation.resume(returning: [])
                    return
                }
                var days: [StepsDay] = []
                collection.enumerateStatistics(from: startDate, to: today) { statistics, _ in
                    let value = statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0
                    days.append(StepsDay(date: statistics.startDate, count: Int(value)))
                }
                continuation.resume(returning: days)
            }
            healthStore.execute(query)
        }
    }
}
