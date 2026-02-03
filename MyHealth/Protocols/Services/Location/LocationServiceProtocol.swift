//
//  LocationServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Models

public protocol LocationServiceProtocol {
    func currentLocation() -> WorkoutRoutePoint?
    func locationUpdates() -> AsyncStream<WorkoutRoutePoint>
}
