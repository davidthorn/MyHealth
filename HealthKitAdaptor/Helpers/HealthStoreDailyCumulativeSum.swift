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
        let window = dayRangeWindow(days: safeDays, endingAt: endDate, calendar: calendar)

        return await withCheckedContinuation { continuation in
            let predicate = window.predicate
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
                    results.enumerateStatistics(from: window.start, to: window.end) { statistics, _ in
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
