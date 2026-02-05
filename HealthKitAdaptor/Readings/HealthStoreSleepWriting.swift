//
//  HealthStoreSleepWriting.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

public protocol HealthStoreSleepWriting: HealthStoreSampleQuerying {
}

public extension HealthStoreSleepWriting {
    func saveSleepEntry(_ entry: SleepEntry) async throws {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            throw HealthKitAdapterError.sleepEntrySaveFailed
        }
        let metadata: [String: Any] = [
            HKMetadataKeyWasUserEntered: entry.isUserEntered
        ]
        let sample = HKCategorySample(
            type: sleepType,
            value: entry.category.healthKitValue.rawValue,
            start: entry.startDate,
            end: entry.endDate,
            metadata: metadata
        )
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            healthStore.save(sample) { success, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                if success {
                    continuation.resume(returning: ())
                } else {
                    continuation.resume(throwing: HealthKitAdapterError.sleepEntrySaveFailed)
                }
            }
        }
    }
}
