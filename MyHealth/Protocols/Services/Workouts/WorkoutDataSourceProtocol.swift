//
//  WorkoutDataSourceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol WorkoutDataSourceProtocol {
    func requestAuthorization() async -> Bool
    func requestDeleteAuthorization() async -> Bool
    func workoutsStream() -> AsyncStream<[Workout]>
    func workoutRoute(id: UUID) async throws -> [WorkoutRoutePoint]
    func deleteWorkout(id: UUID) async throws
}
