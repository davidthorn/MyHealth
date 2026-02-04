//
//  HealthStoreSampleQuerying.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import CoreLocation
import Foundation
import HealthKit

public protocol HealthStoreSampleQuerying {
    var healthStore: HKHealthStore { get }
}

public extension HealthStoreSampleQuerying {
    func fetchSamples<T: HKSample>(
        sampleType: HKSampleType,
        predicate: NSPredicate?,
        limit: Int,
        sortDescriptors: [NSSortDescriptor]?
    ) async -> [T] {
        await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: sampleType,
                predicate: predicate,
                limit: limit,
                sortDescriptors: sortDescriptors
            ) { _, samples, _ in
                let results = (samples as? [T]) ?? []
                continuation.resume(returning: results)
            }
            healthStore.execute(query)
        }
    }

    func fetchSample<T: HKSample>(
        sampleType: HKSampleType,
        predicate: NSPredicate,
        errorOnMissing: Error
    ) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
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
                guard let sample = (samples as? [T])?.first else {
                    continuation.resume(throwing: errorOnMissing)
                    return
                }
                continuation.resume(returning: sample)
            }
            healthStore.execute(query)
        }
    }

    func fetchSample<T: HKSample>(
        sampleType: HKSampleType,
        id: UUID,
        errorOnMissing: Error
    ) async throws -> T {
        let predicate = HKQuery.predicateForObject(with: id)
        return try await fetchSample(
            sampleType: sampleType,
            predicate: predicate,
            errorOnMissing: errorOnMissing
        )
    }

    func fetchQuantitySamples(
        quantityType: HKQuantityType,
        predicate: NSPredicate?,
        limit: Int,
        sortDescriptors: [NSSortDescriptor]?
    ) async -> [HKQuantitySample] {
        await fetchSamples(
            sampleType: quantityType,
            predicate: predicate,
            limit: limit,
            sortDescriptors: sortDescriptors
        )
    }

    func fetchCategorySamples(
        categoryType: HKCategoryType,
        predicate: NSPredicate?,
        limit: Int,
        sortDescriptors: [NSSortDescriptor]?
    ) async -> [HKCategorySample] {
        await fetchSamples(
            sampleType: categoryType,
            predicate: predicate,
            limit: limit,
            sortDescriptors: sortDescriptors
        )
    }

    func dayWindow(
        for date: Date,
        calendar: Calendar = .current
    ) -> (start: Date, end: Date, predicate: NSPredicate) {
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) ?? startDate
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: endDate,
            options: .strictStartDate
        )
        return (startDate, endDate, predicate)
    }

    func dayRangeWindow(
        days: Int,
        endingAt endDate: Date = Date(),
        calendar: Calendar = .current
    ) -> (start: Date, end: Date, predicate: NSPredicate) {
        let safeDays = max(days, 1)
        let endAnchor = calendar.startOfDay(for: endDate)
        let startDate = calendar.date(byAdding: .day, value: -(safeDays - 1), to: endAnchor) ?? endAnchor
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: endDate,
            options: .strictStartDate
        )
        return (startDate, endDate, predicate)
    }

    func deleteSamples(_ samples: [HKSample]) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            healthStore.delete(samples) { success, error in
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

    func rangePredicate(start: Date, end: Date) -> NSPredicate {
        HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
    }

    func sortByStartDate(ascending: Bool) -> NSSortDescriptor {
        NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: ascending)
    }

    func sortByEndDate(ascending: Bool) -> NSSortDescriptor {
        NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: ascending)
    }

    func startOfDay(for date: Date, calendar: Calendar = .current) -> Date {
        calendar.startOfDay(for: date)
    }

    func fetchWorkoutRouteLocations(_ route: HKWorkoutRoute) async throws -> [CLLocation] {
        try await withCheckedThrowingContinuation { continuation in
            var collected: [CLLocation] = []
            var didResume = false
            let query = HKWorkoutRouteQuery(route: route) { _, locations, done, error in
                if let error, !didResume {
                    didResume = true
                    continuation.resume(throwing: error)
                    return
                }
                if let locations {
                    collected.append(contentsOf: locations)
                }
                if done, !didResume {
                    didResume = true
                    continuation.resume(returning: collected)
                }
            }
            healthStore.execute(query)
        }
    }
}
