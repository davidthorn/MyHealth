//
//  HealthStoreDailyCumulativeSum.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import HealthKit

internal extension HealthStoreSampleQuerying {
    func fetchDailyCumulativeSum<T>(
        quantityType: HKQuantityType,
        unit: HKUnit,
        days: Int,
        mapper: @escaping (Date, Double) -> T
    ) async -> [T] {
        let safeDays = max(days, 1)
        let calendar = Calendar.current
        let endDate = Date()
        let anchorDate = calendar.startOfDay(for: endDate)
        guard let startDate = calendar.date(byAdding: .day, value: -(safeDays - 1), to: anchorDate) else {
            return []
        }

        return await withCheckedContinuation { continuation in
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            let interval = DateComponents(day: 1)
            let query = HKStatisticsCollectionQuery(
                quantityType: quantityType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum,
                anchorDate: anchorDate,
                intervalComponents: interval
            )
            query.initialResultsHandler = { _, results, _ in
                var items: [T] = []
                if let results {
                    results.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                        let value = statistics.sumQuantity()?.doubleValue(for: unit) ?? 0
                        items.append(mapper(statistics.startDate, value))
                    }
                }
                continuation.resume(returning: items)
            }
            healthStore.execute(query)
        }
    }
}
