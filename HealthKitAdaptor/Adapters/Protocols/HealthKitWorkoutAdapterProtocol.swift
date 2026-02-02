//
//  HealthKitWorkoutAdapterProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

@MainActor
public protocol HealthKitWorkoutAdapterProtocol {
    func requestAuthorization() async -> Bool
    func workoutsStream() -> AsyncStream<[Workout]>
    func workout(id: UUID) async throws -> Workout
    func workoutRoute(id: UUID) async throws -> [WorkoutRoutePoint]
    func deleteWorkout(id: UUID) async throws
    func beginWorkout(type: WorkoutType) async throws
    func pauseWorkout() async throws
    func resumeWorkout() async throws
    func endWorkout() async throws
}
