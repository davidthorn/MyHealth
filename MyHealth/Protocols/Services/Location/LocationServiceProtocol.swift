//
//  LocationServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Models

public protocol LocationServiceProtocol {
    func locationUpdates() -> AsyncStream<WorkoutRoutePoint>
}
