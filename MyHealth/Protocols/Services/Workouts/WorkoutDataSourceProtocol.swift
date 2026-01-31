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
    func workoutsStream() -> AsyncStream<[Workout]>
    func deleteWorkout(id: UUID) async throws
}
