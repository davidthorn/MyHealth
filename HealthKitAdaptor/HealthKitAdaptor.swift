//
//  HealthKitAdapter.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Foundation
import Models

@MainActor
public final class HealthKitAdapter: HealthKitAdapterProtocol {
    private let workouts: HealthKitWorkoutAdapterProtocol
    
    public init(workouts: HealthKitWorkoutAdapterProtocol) {
        self.workouts = workouts
    }

    public static func live() -> HealthKitAdapter {
        HealthKitAdapter(workouts: HealthKitWorkoutAdapter())
    }
    
    public func requestAuthorization() async -> Bool {
        await workouts.requestAuthorization()
    }
    
    public func workoutsStream() -> AsyncStream<[Workout]> {
        workouts.workoutsStream()
    }

    public func workout(id: UUID) async throws -> Workout? {
        try await workouts.workout(id: id)
    }

    public func deleteWorkout(id: UUID) async throws {
        try await workouts.deleteWorkout(id: id)
    }
}

public enum HealthKitAdapterError: Error {
    case deleteFailed
    case workoutNotFound
    case unmappedWorkoutType
}
