//
//  WorkoutLocationManaging.swift
//  MyHealth
//
//  Created by Codex.
//

import Models

public protocol WorkoutLocationManaging {
    func reset()
    func shouldAppend(point: WorkoutRoutePoint) -> Bool
}
