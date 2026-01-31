//
//  HealthKitWorkoutAdapter.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

@MainActor
public final class HealthKitWorkoutAdapter: HealthKitWorkoutAdapterProtocol {
    private let healthStore: HKHealthStore

    public init(healthStore: HKHealthStore = HKHealthStore()) {
        self.healthStore = healthStore
    }

    public func requestAuthorization() async -> Bool {
        guard HKHealthStore.isHealthDataAvailable() else { return false }
        let workoutType = HKObjectType.workoutType()
        return await withCheckedContinuation { continuation in
            healthStore.requestAuthorization(toShare: [], read: [workoutType]) { success, _ in
                continuation.resume(returning: success)
            }
        }
    }

    public func workoutsStream() -> AsyncStream<[Workout]> {
        AsyncStream { continuation in
            let task = Task { [healthStore] in
                let workouts = await HealthKitWorkoutAdapter.fetchWorkouts(from: healthStore)
                continuation.yield(workouts)
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    public func workout(id: UUID) async throws -> Workout {
        try await HealthKitWorkoutAdapter.fetchWorkout(from: healthStore, matching: id)
    }

    public func deleteWorkout(id: UUID) async throws {
        let workout = try await HealthKitWorkoutAdapter.fetchHealthKitWorkout(from: healthStore, matching: id)
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

    private static func fetchWorkouts(from healthStore: HKHealthStore) async -> [Workout] {
        await withCheckedContinuation { continuation in
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

    private static func fetchWorkout(from healthStore: HKHealthStore, matching id: UUID) async throws -> Workout {
        let workout = try await fetchHealthKitWorkout(from: healthStore, matching: id)
        guard let model = Workout(healthKitWorkout: workout) else {
            throw HealthKitAdapterError.unmappedWorkoutType
        }
        return model
    }

    private static func fetchHealthKitWorkout(from healthStore: HKHealthStore, matching id: UUID) async throws -> HKWorkout {
        try await withCheckedThrowingContinuation { continuation in
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
}
