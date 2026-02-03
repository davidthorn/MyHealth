//
//  HealthKitWorkoutAdapterProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol HealthKitWorkoutAdapterProtocol: Sendable {
    func requestAuthorization() async -> Bool
    func workoutsStream() -> AsyncStream<[Workout]>
    func workout(id: UUID) async throws -> Workout
    func workoutRoute(id: UUID) async throws -> [WorkoutRoutePoint]
    func deleteWorkout(id: UUID) async throws
}
