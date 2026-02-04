//
//  HealthStoreDailyDiscreteStats.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import HealthKit

internal extension HealthStoreSampleQuerying {
    func fetchDailyDiscreteStats<T>(
        quantityType: HKQuantityType,
        unit: HKUnit,
        days: Int,
        mapper: @escaping (Date, Double?, Double?, Double?) -> T
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
                options: [.discreteAverage, .discreteMin, .discreteMax],
                anchorDate: anchorDate,
                intervalComponents: interval
            )
            query.initialResultsHandler = { _, collection, _ in
                guard let collection else {
                    continuation.resume(returning: [])
                    return
                }
                var items: [T] = []
                collection.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                    let avg = statistics.averageQuantity()?.doubleValue(for: unit)
                    let min = statistics.minimumQuantity()?.doubleValue(for: unit)
                    let max = statistics.maximumQuantity()?.doubleValue(for: unit)
                    items.append(mapper(statistics.startDate, avg, min, max))
                }
                continuation.resume(returning: items)
            }
            healthStore.execute(query)
        }
    }
}
