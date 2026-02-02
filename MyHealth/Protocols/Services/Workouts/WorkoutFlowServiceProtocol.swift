//
//  WorkoutFlowServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol WorkoutFlowServiceProtocol {
    func updates() -> AsyncStream<WorkoutFlowUpdate>
    func startWorkout(type: WorkoutType)
    func beginWorkout()
    func pauseWorkout()
    func resumeWorkout()
    func endWorkout() async throws
}
