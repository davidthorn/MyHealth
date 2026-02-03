//
//  HealthStoreStandHoursReading.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

internal protocol HealthStoreStandHoursReading {
    var healthStore: HKHealthStore { get }
}

extension HealthStoreStandHoursReading {
    public func fetchStandHourCounts(days: Int) async -> [StandHourDay] {
        guard let standType = HKObjectType.categoryType(forIdentifier: .appleStandHour) else { return [] }
        let safeDays = max(days, 1)
        let calendar = Calendar.current
        let endDate = Date()
        let anchorDate = calendar.startOfDay(for: endDate)
        guard let startDate = calendar.date(byAdding: .day, value: -(safeDays - 1), to: anchorDate) else {
            return []
        }
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        return await withCheckedContinuation { continuation in
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            let query = HKSampleQuery(
                sampleType: standType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, _ in
                let standSamples = (samples as? [HKCategorySample]) ?? []
                var counts: [Date: Int] = [:]
                for sample in standSamples where sample.value == HKCategoryValueAppleStandHour.stood.rawValue {
                    let day = calendar.startOfDay(for: sample.startDate)
                    counts[day, default: 0] += 1
                }
                var days: [StandHourDay] = []
                let dayRange = (0..<safeDays).compactMap { calendar.date(byAdding: .day, value: -$0, to: anchorDate) }
                for day in dayRange {
                    let count = counts[day] ?? 0
                    days.append(StandHourDay(date: day, count: count))
                }
                let sorted = days.sorted { $0.date > $1.date }
                continuation.resume(returning: sorted)
            }
            healthStore.execute(query)
        }
    }
}
