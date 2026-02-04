//
//  HealthStoreSleepReading.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

public protocol HealthStoreSleepReading {
    var healthStore: HKHealthStore { get }
}

public extension HealthStoreSleepReading where Self: HealthStoreSampleQuerying {
    func fetchSleepAnalysis(days: Int) async -> [SleepDay] {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return [] }
        let safeDays = max(days, 1)
        let calendar = Calendar.current
        let endDate = Date()
        let anchorDate = calendar.startOfDay(for: endDate)
        guard let startDate = calendar.date(byAdding: .day, value: -(safeDays - 1), to: anchorDate) else {
            return []
        }
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let sleepSamples: [HKCategorySample] = await fetchSamples(
            sampleType: sleepType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]
        )
        var durations: [Date: TimeInterval] = [:]
        for sample in sleepSamples {
            let category = HKCategoryValueSleepAnalysis(rawValue: sample.value)
            guard category == .asleepUnspecified || category == .asleepCore || category == .asleepDeep || category == .asleepREM else { continue }
            let day = calendar.startOfDay(for: sample.startDate)
            durations[day, default: 0] += sample.endDate.timeIntervalSince(sample.startDate)
        }
        var days: [SleepDay] = []
        let dayRange = (0..<safeDays).compactMap { calendar.date(byAdding: .day, value: -$0, to: anchorDate) }
        for day in dayRange {
            let duration = durations[day] ?? 0
            days.append(SleepDay(date: day, durationSeconds: duration))
        }
        return days.sorted { $0.date > $1.date }
    }
    
    func fetchSleepAnalysisDay(date: Date) async -> SleepDay {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            return SleepDay(date: Calendar.current.startOfDay(for: date), durationSeconds: 0)
        }
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else {
            return SleepDay(date: startDate, durationSeconds: 0)
        }
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let sleepSamples: [HKCategorySample] = await fetchSamples(
            sampleType: sleepType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]
        )
        var duration: TimeInterval = 0
        for sample in sleepSamples {
            let category = HKCategoryValueSleepAnalysis(rawValue: sample.value)
            guard category == .asleepUnspecified || category == .asleepCore || category == .asleepDeep || category == .asleepREM else { continue }
            duration += sample.endDate.timeIntervalSince(sample.startDate)
        }
        return SleepDay(date: startDate, durationSeconds: duration)
    }
}
