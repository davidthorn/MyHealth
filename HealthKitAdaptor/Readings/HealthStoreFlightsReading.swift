//
//  HealthStoreFlightsReading.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

@MainActor
internal protocol HealthStoreFlightsReading {
    var healthStore: HKHealthStore { get }
}

@MainActor
extension HealthStoreFlightsReading {
    public func fetchFlightCounts(days: Int) async -> [FlightsDay] {
        guard let flightsType = HKQuantityType.quantityType(forIdentifier: .flightsClimbed) else { return [] }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let startDate = calendar.date(byAdding: .day, value: -(days - 1), to: today) ?? today

        return await withCheckedContinuation { continuation in
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: today, options: .strictStartDate)
            let interval = DateComponents(day: 1)
            let query = HKStatisticsCollectionQuery(
                quantityType: flightsType,
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
                var days: [FlightsDay] = []
                collection.enumerateStatistics(from: startDate, to: today) { statistics, _ in
                    let value = statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0
                    days.append(FlightsDay(date: statistics.startDate, count: Int(value)))
                }
                continuation.resume(returning: days)
            }
            healthStore.execute(query)
        }
    }
}
