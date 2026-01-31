//
//  HealthKitAdapter.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKit
import Models

@MainActor
public final class HealthKitAdapter: HealthKitAdapterProtocol {
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
                let workouts = await HealthKitAdapter.fetchWorkouts(from: healthStore)
                continuation.yield(workouts)
            }
            continuation.onTermination = { _ in
                task.cancel()
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
}
