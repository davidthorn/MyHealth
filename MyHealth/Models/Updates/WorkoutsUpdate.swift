//
//  WorkoutsUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public struct WorkoutsUpdate: Sendable {
    public let title: String
    public let workouts: [Workout]

    public init(title: String, workouts: [Workout]) {
        self.title = title
        self.workouts = workouts
    }
}
