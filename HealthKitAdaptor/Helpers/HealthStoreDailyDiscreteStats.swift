//
//  HealthStoreDailyDiscreteStats.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import HealthKit

struct DailyDiscreteStats {
    let date: Date
    let average: Double?
    let minimum: Double?
    let maximum: Double?
}

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
        let window = dayRangeWindow(days: safeDays, endingAt: endDate, calendar: calendar)

        return await withCheckedContinuation { continuation in
            let predicate = window.predicate
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
                collection.enumerateStatistics(from: window.start, to: window.end) { statistics, _ in
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

    func fetchDailyDiscreteStats(
        quantityType: HKQuantityType,
        unit: HKUnit,
        days: Int
    ) async -> [DailyDiscreteStats] {
        await fetchDailyDiscreteStats(
            quantityType: quantityType,
            unit: unit,
            days: days
        ) { date, avg, min, max in
            DailyDiscreteStats(date: date, average: avg, minimum: min, maximum: max)
        }
    }
}
