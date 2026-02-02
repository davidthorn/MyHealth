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
    private let storeAdaptor: HealthStoreAdaptorProtocol
    private var currentType: WorkoutType?
    private var startedAt: Date?
    private var pausedAt: Date?
    private var totalPaused: TimeInterval
    private var workoutBuilder: HKWorkoutBuilder?

    public init(storeAdaptor: HealthStoreAdaptorProtocol) {
        self.storeAdaptor = storeAdaptor
        self.currentType = nil
        self.startedAt = nil
        self.pausedAt = nil
        self.totalPaused = 0
        self.workoutBuilder = nil
    }

    public static func live() -> HealthKitWorkoutAdapter {
        HealthKitWorkoutAdapter(storeAdaptor: HealthStoreAdaptor())
    }

    public func requestAuthorization() async -> Bool {
        await storeAdaptor.authorizationProvider.requestWorkoutAuthorization()
    }

    public func workoutsStream() -> AsyncStream<[Workout]> {
        AsyncStream { continuation in
            let task = Task { [storeAdaptor] in
                let workouts = await storeAdaptor.fetchWorkouts()
                continuation.yield(workouts)
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    public func workout(id: UUID) async throws -> Workout {
        try await storeAdaptor.fetchWorkout(id: id)
    }

    public func workoutRoute(id: UUID) async throws -> [WorkoutRoutePoint] {
        try await storeAdaptor.fetchWorkoutRoute(id: id)
    }

    public func deleteWorkout(id: UUID) async throws {
        try await storeAdaptor.deleteWorkout(id: id)
    }

    public func beginWorkout(type: WorkoutType) async throws {
        let workoutType = HKObjectType.workoutType()
        
        let authorized = await storeAdaptor.authorizationProvider.requestCreateWorkoutAuthorization()
        guard authorized else {
            throw HealthKitAdapterError.workoutWriteDenied
        }
        
        guard startedAt == nil else {
            throw HealthKitAdapterError.workoutSessionAlreadyActive
        }
        
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = type.healthKitActivityType
        configuration.locationType = type.healthKitLocationType

        let builder = HKWorkoutBuilder(
            healthStore: storeAdaptor.healthStore,
            configuration: configuration,
            device: nil
        )
        let startDate = Date()
        try await builder.beginCollection(at: startDate)

        workoutBuilder = builder
        currentType = type
        startedAt = startDate
        pausedAt = nil
        totalPaused = 0
    }

    public func pauseWorkout() async throws {
        guard startedAt != nil else {
            throw HealthKitAdapterError.workoutSessionNotStarted
        }
        guard pausedAt == nil else { return }
        pausedAt = Date()
    }

    public func resumeWorkout() async throws {
        guard startedAt != nil else {
            throw HealthKitAdapterError.workoutSessionNotStarted
        }
        guard let pausedAt else { return }
        totalPaused += Date().timeIntervalSince(pausedAt)
        self.pausedAt = nil
    }

    public func endWorkout() async throws {
        guard startedAt != nil, let builder = workoutBuilder else {
            throw HealthKitAdapterError.workoutSessionNotStarted
        }
        let endDate = Date()
        try await builder.endCollection(at: endDate)
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            builder.finishWorkout { _, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume(returning: ())
            }
        }

        currentType = nil
        startedAt = nil
        pausedAt = nil
        totalPaused = 0
        workoutBuilder = nil
    }
}
