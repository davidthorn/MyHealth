//
//  WorkoutRoutePoint.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct WorkoutRoutePoint: Codable, Hashable, Sendable, Identifiable {
    public let id: UUID
    public let latitude: Double
    public let longitude: Double
    public let timestamp: Date
    public let horizontalAccuracy: Double?

    public init(
        id: UUID = UUID(),
        latitude: Double,
        longitude: Double,
        timestamp: Date,
        horizontalAccuracy: Double?
    ) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
        self.horizontalAccuracy = horizontalAccuracy
    }
}
