//
//  WorkoutStoreSource.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models
import HealthKitAdaptor

public final class WorkoutStoreSource: WorkoutDataSourceProtocol {
    private let healthKitAdapter: HealthKitAdapterProtocol

    public init(healthKitAdapter: HealthKitAdapterProtocol) {
        self.healthKitAdapter = healthKitAdapter
    }

    public func requestAuthorization() async -> Bool {
        await healthKitAdapter.authorizationProvider.requestWorkoutAuthorization()
    }

    public func requestDeleteAuthorization() async -> Bool {
        await healthKitAdapter.authorizationProvider.requestCreateWorkoutAuthorization()
    }

    public func workoutsStream() -> AsyncStream<[Workout]> {
        healthKitAdapter.workoutsStream()
    }

    public func workoutRoute(id: UUID) async throws -> [WorkoutRoutePoint] {
        try await healthKitAdapter.workoutRoute(id: id)
    }

    public func deleteWorkout(id: UUID) async throws {
        try await healthKitAdapter.deleteWorkout(id: id)
    }
}
