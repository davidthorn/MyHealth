//
//  HealthKitWorkoutAdapter.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public final class HealthKitWorkoutAdapter: HealthKitWorkoutAdapterProtocol {
    private let storeAdaptor: HealthStoreAdaptorProtocol

    public init(storeAdaptor: HealthStoreAdaptorProtocol) {
        self.storeAdaptor = storeAdaptor
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
}
