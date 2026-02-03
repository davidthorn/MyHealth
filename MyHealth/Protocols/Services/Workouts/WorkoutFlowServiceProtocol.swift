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
    func beginWorkout() async throws
    func pauseWorkout() async throws
    func resumeWorkout() async throws
    func appendRoutePoint(_ point: WorkoutRoutePoint) async throws
    func endWorkout() async throws
}
