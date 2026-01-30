//
//  WorkoutFlowServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public protocol WorkoutFlowServiceProtocol {
    func updates() -> AsyncStream<WorkoutFlowUpdate>
    func startWorkout(type: WorkoutType)
    func endWorkout() async throws
}
