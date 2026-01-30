//
//  WorkoutsUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public struct WorkoutsUpdate: Sendable {
    public let title: String
    public let workouts: [WorkoutSummary]

    public init(title: String, workouts: [WorkoutSummary]) {
        self.title = title
        self.workouts = workouts
    }
}
