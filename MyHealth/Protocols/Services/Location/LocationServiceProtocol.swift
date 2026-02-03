//
//  LocationServiceProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import CoreLocation
import Models

public protocol LocationServiceProtocol {
    func currentLocation() -> WorkoutRoutePoint?
    func currentAuthorizationStatus() -> CLAuthorizationStatus
    func authorizationUpdates() -> AsyncStream<CLAuthorizationStatus>
    func requestWhenInUseAuthorization()
    func requestAlwaysAuthorization()
    func startLocationUpdates()
    func stopLocationUpdates()
    func locationUpdates() -> AsyncStream<WorkoutRoutePoint>
}
