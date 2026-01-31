//
//  HealthStoreAdaptor.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

@MainActor
public final class HealthStoreAdaptor: HealthStoreAdaptorProtocol {
    private let healthStore: HKHealthStore

    public init(healthStore: HKHealthStore = HKHealthStore()) {
        self.healthStore = healthStore
    }

    public func requestWorkoutAuthorization() async -> Bool {
        guard HKHealthStore.isHealthDataAvailable() else { return false }
        let workoutType = HKObjectType.workoutType()
        return await withCheckedContinuation { continuation in
            healthStore.requestAuthorization(toShare: [], read: [workoutType]) { success, _ in
                continuation.resume(returning: success)
            }
        }
    }

    public func requestHeartRateAuthorization() async -> Bool {
        guard HKHealthStore.isHealthDataAvailable() else { return false }
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return false }
        return await withCheckedContinuation { continuation in
            healthStore.requestAuthorization(toShare: [], read: [heartRateType]) { success, _ in
                continuation.resume(returning: success)
            }
        }
    }

    public func requestStepsAuthorization() async -> Bool {
        guard HKHealthStore.isHealthDataAvailable() else { return false }
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return false }
        return await withCheckedContinuation { continuation in
            healthStore.requestAuthorization(toShare: [], read: [stepType]) { success, _ in
                continuation.resume(returning: success)
            }
        }
    }

    public func requestFlightsAuthorization() async -> Bool {
        guard HKHealthStore.isHealthDataAvailable() else { return false }
        guard let flightsType = HKQuantityType.quantityType(forIdentifier: .flightsClimbed) else { return false }
        return await withCheckedContinuation { continuation in
            healthStore.requestAuthorization(toShare: [], read: [flightsType]) { success, _ in
                continuation.resume(returning: success)
            }
        }
    }

    public func requestStandHoursAuthorization() async -> Bool {
        guard HKHealthStore.isHealthDataAvailable() else { return false }
        guard let standType = HKObjectType.categoryType(forIdentifier: .appleStandHour) else { return false }
        return await withCheckedContinuation { continuation in
            healthStore.requestAuthorization(toShare: [], read: [standType]) { success, _ in
                continuation.resume(returning: success)
            }
        }
    }

    public func requestActiveEnergyAuthorization() async -> Bool {
        guard HKHealthStore.isHealthDataAvailable() else { return false }
        guard let activeType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else { return false }
        return await withCheckedContinuation { continuation in
            healthStore.requestAuthorization(toShare: [], read: [activeType]) { success, _ in
                continuation.resume(returning: success)
            }
        }
    }

    public func requestSleepAnalysisAuthorization() async -> Bool {
        guard HKHealthStore.isHealthDataAvailable() else { return false }
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return false }
        return await withCheckedContinuation { continuation in
            healthStore.requestAuthorization(toShare: [], read: [sleepType]) { success, _ in
                continuation.resume(returning: success)
            }
        }
    }

    public func requestActivitySummaryAuthorization() async -> Bool {
        guard HKHealthStore.isHealthDataAvailable() else { return false }
        let summaryType = HKObjectType.activitySummaryType()
        return await withCheckedContinuation { continuation in
            healthStore.requestAuthorization(toShare: [], read: [summaryType]) { success, _ in
                continuation.resume(returning: success)
            }
        }
    }

    public func fetchWorkouts() async -> [Workout] {
        return await withCheckedContinuation { continuation in
            let sampleType = HKObjectType.workoutType()
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let query = HKSampleQuery(
                sampleType: sampleType,
                predicate: nil,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, _ in
                let workouts = (samples as? [HKWorkout])?.compactMap(Workout.init(healthKitWorkout:)) ?? []
                continuation.resume(returning: workouts)
            }
            healthStore.execute(query)
        }
    }

    public func fetchWorkout(id: UUID) async throws -> Workout {
        let workout = try await fetchHealthKitWorkout(id: id)
        guard let model = Workout(healthKitWorkout: workout) else {
            throw HealthKitAdapterError.unmappedWorkoutType
        }
        return model
    }

    public func deleteWorkout(id: UUID) async throws {
        let workout = try await fetchHealthKitWorkout(id: id)
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            healthStore.delete([workout]) { success, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                if success {
                    continuation.resume(returning: ())
                } else {
                    continuation.resume(throwing: HealthKitAdapterError.deleteFailed)
                }
            }
        }
    }

    private func fetchHealthKitWorkout(id: UUID) async throws -> HKWorkout {
        return try await withCheckedThrowingContinuation { continuation in
            let sampleType = HKObjectType.workoutType()
            let predicate = HKQuery.predicateForObject(with: id)
            let query = HKSampleQuery(
                sampleType: sampleType,
                predicate: predicate,
                limit: 1,
                sortDescriptors: nil
            ) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let workout = (samples as? [HKWorkout])?.first else {
                    continuation.resume(throwing: HealthKitAdapterError.workoutNotFound)
                    return
                }
                continuation.resume(returning: workout)
            }
            healthStore.execute(query)
        }
    }

    public func fetchHeartRateReadings(limit: Int) async -> [HeartRateReading] {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return [] }
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: heartRateType,
                predicate: nil,
                limit: limit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, _ in
                let readings: [HeartRateReading] = (samples as? [HKQuantitySample])?.map(HeartRateReading.init) ?? []
                continuation.resume(returning: readings)
            }
            healthStore.execute(query)
        }
    }

    public func fetchHeartRateReading(id: UUID) async throws -> HeartRateReading {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            throw HealthKitAdapterError.heartRateReadingNotFound
        }
        return try await withCheckedThrowingContinuation { continuation in
            let predicate = HKQuery.predicateForObject(with: id)
            let query = HKSampleQuery(
                sampleType: heartRateType,
                predicate: predicate,
                limit: 1,
                sortDescriptors: nil
            ) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let sample = (samples as? [HKQuantitySample])?.first else {
                    continuation.resume(throwing: HealthKitAdapterError.heartRateReadingNotFound)
                    return
                }
                let reading = HeartRateReading(sample: sample)
                continuation.resume(returning: reading)
            }
            healthStore.execute(query)
        }
    }

    public func fetchStepCounts(days: Int) async -> [StepsDay] {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return [] }
        let safeDays = max(days, 1)
        let calendar = Calendar.current
        let endDate = Date()
        let anchorDate = calendar.startOfDay(for: endDate)
        guard let startDate = calendar.date(byAdding: .day, value: -(safeDays - 1), to: anchorDate) else {
            return []
        }
        let interval = DateComponents(day: 1)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        return await withCheckedContinuation { continuation in
            let query = HKStatisticsCollectionQuery(
                quantityType: stepType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum,
                anchorDate: anchorDate,
                intervalComponents: interval
            )
            query.initialResultsHandler = { _, results, _ in
                var days: [StepsDay] = []
                if let results {
                    results.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                        let count = statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0
                        days.append(StepsDay(date: statistics.startDate, count: Int(count.rounded())))
                    }
                }
                let sorted = days.sorted { $0.date > $1.date }
                continuation.resume(returning: sorted)
            }
            healthStore.execute(query)
        }
    }

    public func fetchFlightCounts(days: Int) async -> [FlightsDay] {
        guard let flightsType = HKQuantityType.quantityType(forIdentifier: .flightsClimbed) else { return [] }
        let safeDays = max(days, 1)
        let calendar = Calendar.current
        let endDate = Date()
        let anchorDate = calendar.startOfDay(for: endDate)
        guard let startDate = calendar.date(byAdding: .day, value: -(safeDays - 1), to: anchorDate) else {
            return []
        }
        let interval = DateComponents(day: 1)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        return await withCheckedContinuation { continuation in
            let query = HKStatisticsCollectionQuery(
                quantityType: flightsType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum,
                anchorDate: anchorDate,
                intervalComponents: interval
            )
            query.initialResultsHandler = { _, results, _ in
                var days: [FlightsDay] = []
                if let results {
                    results.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                        let count = statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0
                        days.append(FlightsDay(date: statistics.startDate, count: Int(count.rounded())))
                    }
                }
                let sorted = days.sorted { $0.date > $1.date }
                continuation.resume(returning: sorted)
            }
            healthStore.execute(query)
        }
    }

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

    public func fetchActiveEnergy(days: Int) async -> [CaloriesDay] {
        guard let activeType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else { return [] }
        let safeDays = max(days, 1)
        let calendar = Calendar.current
        let endDate = Date()
        let anchorDate = calendar.startOfDay(for: endDate)
        guard let startDate = calendar.date(byAdding: .day, value: -(safeDays - 1), to: anchorDate) else {
            return []
        }
        let interval = DateComponents(day: 1)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        return await withCheckedContinuation { continuation in
            let query = HKStatisticsCollectionQuery(
                quantityType: activeType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum,
                anchorDate: anchorDate,
                intervalComponents: interval
            )
            query.initialResultsHandler = { _, results, _ in
                var days: [CaloriesDay] = []
                if let results {
                    results.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                        let kcal = statistics.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
                        days.append(CaloriesDay(date: statistics.startDate, activeKilocalories: kcal))
                    }
                }
                let sorted = days.sorted { $0.date > $1.date }
                continuation.resume(returning: sorted)
            }
            healthStore.execute(query)
        }
    }

    public func fetchActivitySummaries(days: Int) async -> [ActivityRingsDay] {
        let safeDays = max(days, 1)
        let calendar = Calendar.current
        let endDate = Date()
        let anchorDate = calendar.startOfDay(for: endDate)
        guard let startDate = calendar.date(byAdding: .day, value: -(safeDays - 1), to: anchorDate) else {
            return []
        }
        let descriptor = HKActivitySummaryQueryDescriptor(predicate: nil)
        do {
            let summaries = try await descriptor.result(for: healthStore)
            let days = summaries.compactMap { $0.activityRingsDay(calendar: calendar) }
            let filtered = days.filter { $0.date >= startDate && $0.date <= anchorDate }
            return filtered.sorted { $0.date > $1.date }
        } catch {
            return []
        }
    }

    public func fetchActivitySummaryDay(date: Date) async -> ActivityRingsDay {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        var components = calendar.dateComponents([.year, .month, .day], from: startDate)
        components.calendar = calendar
        let predicate = HKQuery.predicateForActivitySummary(with: components)
        let descriptor = HKActivitySummaryQueryDescriptor(predicate: predicate)
        do {
            let summaries = try await descriptor.result(for: healthStore)
            if let summary = summaries.first?.activityRingsDay(calendar: calendar) {
                return summary
            }
        } catch {
            // fall through to default
        }
        return ActivityRingsDay(
            date: startDate,
            moveValue: 0,
            moveGoal: 0,
            exerciseMinutes: 0,
            exerciseGoal: 0,
            standHours: 0,
            standGoal: 0
        )
    }

    public func fetchSleepAnalysis(days: Int) async -> [SleepDay] {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return [] }
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
                sampleType: sleepType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, _ in
                let sleepSamples = (samples as? [HKCategorySample]) ?? []
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
                let sorted = days.sorted { $0.date > $1.date }
                continuation.resume(returning: sorted)
            }
            healthStore.execute(query)
        }
    }

    public func fetchSleepAnalysisDay(date: Date) async -> SleepDay {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            return SleepDay(date: Calendar.current.startOfDay(for: date), durationSeconds: 0)
        }
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else {
            return SleepDay(date: startDate, durationSeconds: 0)
        }
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        return await withCheckedContinuation { continuation in
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            let query = HKSampleQuery(
                sampleType: sleepType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, _ in
                let sleepSamples = (samples as? [HKCategorySample]) ?? []
                var duration: TimeInterval = 0
                for sample in sleepSamples {
                    let category = HKCategoryValueSleepAnalysis(rawValue: sample.value)
                    guard category == .asleepUnspecified || category == .asleepCore || category == .asleepDeep || category == .asleepREM else { continue }
                    duration += sample.endDate.timeIntervalSince(sample.startDate)
                }
                continuation.resume(returning: SleepDay(date: startDate, durationSeconds: duration))
            }
            healthStore.execute(query)
        }
    }
}
