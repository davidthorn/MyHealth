//
//  DashboardLatestWorkout.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct DashboardLatestWorkout: Codable, Hashable, Sendable {
    public let workout: Workout
    public let routePoints: [WorkoutRoutePoint]
    public let heartRatePoints: [HeartRateRangePoint]

    public init(
        workout: Workout,
        routePoints: [WorkoutRoutePoint],
        heartRatePoints: [HeartRateRangePoint]
    ) {
        self.workout = workout
        self.routePoints = routePoints
        self.heartRatePoints = heartRatePoints
    }
}
