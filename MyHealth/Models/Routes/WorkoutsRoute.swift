//
//  WorkoutsRoute.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public enum WorkoutsRoute: Hashable {
    case workout(UUID)
    case newWorkout

    public init(workout: UUID) {
        self = .workout(workout)
    }

    public init() {
        self = .newWorkout
    }
}
