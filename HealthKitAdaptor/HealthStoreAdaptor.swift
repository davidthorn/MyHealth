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

}
