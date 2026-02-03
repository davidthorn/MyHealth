//
//  WorkoutLocationManager.swift
//  MyHealth
//
//  Created by Codex.
//

import CoreLocation
import Models

public final class WorkoutLocationManager: WorkoutLocationManaging {
    private let minimumDistance: Double
    private var lastAcceptedPoint: WorkoutRoutePoint?

    public init(minimumDistance: Double = 1) {
        self.minimumDistance = minimumDistance
    }

    public func reset() {
        lastAcceptedPoint = nil
    }

    public func shouldAppend(point: WorkoutRoutePoint) -> Bool {
        guard let lastAcceptedPoint else {
            self.lastAcceptedPoint = point
            return true
        }
        let lastLocation = CLLocation(latitude: lastAcceptedPoint.latitude, longitude: lastAcceptedPoint.longitude)
        let newLocation = CLLocation(latitude: point.latitude, longitude: point.longitude)
        if newLocation.distance(from: lastLocation) < minimumDistance {
            return false
        }
        self.lastAcceptedPoint = point
        return true
    }
}
