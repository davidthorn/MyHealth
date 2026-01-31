//
//  WorkoutListItemUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct WorkoutListItemUpdate: Sendable {
    public let title: String
    public let typeName: String
    public let timeRange: String
    public let durationSeconds: TimeInterval
    public let routePoints: [WorkoutRoutePoint]
    public let distanceMeters: Double?
    public let averageHeartRateBpm: Double?

    public init(
        title: String,
        typeName: String,
        timeRange: String,
        durationSeconds: TimeInterval,
        routePoints: [WorkoutRoutePoint],
        distanceMeters: Double?,
        averageHeartRateBpm: Double?
    ) {
        self.title = title
        self.typeName = typeName
        self.timeRange = timeRange
        self.durationSeconds = durationSeconds
        self.routePoints = routePoints
        self.distanceMeters = distanceMeters
        self.averageHeartRateBpm = averageHeartRateBpm
    }
}
