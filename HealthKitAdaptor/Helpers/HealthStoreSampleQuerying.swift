//
//  HealthStoreSampleQuerying.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

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
}
