//
//  WorkoutDetailUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public struct WorkoutDetailUpdate: Sendable {
    public let workout: Workout?

    public init(workout: Workout?) {
        self.workout = workout
    }
}
