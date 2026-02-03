//
//  HealthKitWorkoutSessionManaging.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol HealthKitWorkoutSessionManaging: Sendable {
    func beginWorkout(type: WorkoutType) async throws
    func pauseWorkout() async throws
    func resumeWorkout() async throws
    func endWorkout() async throws
}
