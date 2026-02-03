//
//  HealthStoreExerciseMinutesReading.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

internal protocol HealthStoreExerciseMinutesReading {
    var healthStore: HKHealthStore { get }
}

extension HealthStoreExerciseMinutesReading {
    public func fetchExerciseMinutes(days: Int) async -> [ExerciseMinutesDay] {
        guard let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime) else { return [] }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let startDate = calendar.date(byAdding: .day, value: -(days - 1), to: today) ?? today

        return await withCheckedContinuation { continuation in
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: today, options: .strictStartDate)
            let interval = DateComponents(day: 1)
            let query = HKStatisticsCollectionQuery(
                quantityType: exerciseType,
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
                var days: [ExerciseMinutesDay] = []
                collection.enumerateStatistics(from: startDate, to: today) { statistics, _ in
                    let value = statistics.sumQuantity()?.doubleValue(for: .minute()) ?? 0
                    days.append(ExerciseMinutesDay(date: statistics.startDate, minutes: value))
                }
                continuation.resume(returning: days)
            }
            healthStore.execute(query)
        }
    }
}
