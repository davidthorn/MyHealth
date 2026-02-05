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
        let calendar = Calendar.current
        let endDate = Date()
        let window = dayRangeWindow(days: days, endingAt: endDate, calendar: calendar)
        let sortDescriptor = sortByStartDate(ascending: false)
        let sleepSamples = await fetchCategorySamples(
            categoryType: sleepType,
            predicate: window.predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]
        )
        var durations: [Date: TimeInterval] = [:]
        for sample in sleepSamples {
            let category = HKCategoryValueSleepAnalysis(rawValue: sample.value)
            guard category == .asleepUnspecified || category == .asleepCore || category == .asleepDeep || category == .asleepREM else { continue }
            let day = startOfDay(for: sample.startDate, calendar: calendar)
            durations[day, default: 0] += sample.endDate.timeIntervalSince(sample.startDate)
        }
        var sleepDays: [SleepDay] = []
        let safeDays = max(days, 1)
        let anchorDate = startOfDay(for: endDate, calendar: calendar)
        let dayRange = (0..<safeDays).compactMap { calendar.date(byAdding: .day, value: -$0, to: anchorDate) }
        for day in dayRange {
            let duration = durations[day] ?? 0
            sleepDays.append(SleepDay(date: day, durationSeconds: duration))
        }
        return sleepDays.sorted { $0.date > $1.date }
    }
    
    func fetchSleepAnalysisDay(date: Date) async -> SleepDay {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            return SleepDay(date: startOfDay(for: date), durationSeconds: 0)
        }
        let calendar = Calendar.current
        let window = dayWindow(for: date, calendar: calendar)
        let sortDescriptor = sortByStartDate(ascending: false)
        let sleepSamples = await fetchCategorySamples(
            categoryType: sleepType,
            predicate: window.predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]
        )
        var duration: TimeInterval = 0
        for sample in sleepSamples {
            let category = HKCategoryValueSleepAnalysis(rawValue: sample.value)
            guard category == .asleepUnspecified || category == .asleepCore || category == .asleepDeep || category == .asleepREM else { continue }
            duration += sample.endDate.timeIntervalSince(sample.startDate)
        }
        return SleepDay(date: window.start, durationSeconds: duration)
    }

    func fetchSleepEntries(days: Int) async -> [SleepEntry] {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return [] }
        let calendar = Calendar.current
        let endDate = Date()
        let window = dayRangeWindow(days: days, endingAt: endDate, calendar: calendar)
        let sortDescriptor = sortByStartDate(ascending: false)
        let sleepSamples = await fetchCategorySamples(
            categoryType: sleepType,
            predicate: window.predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]
        )
        return sleepSamples.compactMap { sample in
            let categoryValue = HKCategoryValueSleepAnalysis(rawValue: sample.value)
            guard let category = categoryValue.flatMap(SleepEntryCategory.init(healthKitValue:)) else {
                return nil
            }
            let isUserEntered = (sample.metadata?[HKMetadataKeyWasUserEntered] as? Bool) ?? false
            return SleepEntry(
                id: sample.uuid,
                startDate: sample.startDate,
                endDate: sample.endDate,
                category: category,
                isUserEntered: isUserEntered,
                sourceName: sample.sourceRevision.source.name,
                deviceName: sample.device?.name
            )
        }
    }

    func fetchSleepEntries(on date: Date) async -> [SleepEntry] {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return [] }
        let calendar = Calendar.current
        let window = dayWindow(for: date, calendar: calendar)
        let sortDescriptor = sortByStartDate(ascending: false)
        let sleepSamples = await fetchCategorySamples(
            categoryType: sleepType,
            predicate: window.predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]
        )
        return sleepSamples.compactMap { sample in
            let categoryValue = HKCategoryValueSleepAnalysis(rawValue: sample.value)
            guard let category = categoryValue.flatMap(SleepEntryCategory.init(healthKitValue:)) else {
                return nil
            }
            let isUserEntered = (sample.metadata?[HKMetadataKeyWasUserEntered] as? Bool) ?? false
            return SleepEntry(
                id: sample.uuid,
                startDate: sample.startDate,
                endDate: sample.endDate,
                category: category,
                isUserEntered: isUserEntered,
                sourceName: sample.sourceRevision.source.name,
                deviceName: sample.device?.name
            )
        }
    }
}
