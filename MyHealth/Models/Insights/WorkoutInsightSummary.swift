//
//  WorkoutInsightSummary.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct WorkoutInsightSummary: Hashable, Sendable, Identifiable {
    public let id: UUID
    public let type: WorkoutType
    public let startedAt: Date
    public let durationMinutes: Double
    public let distanceMeters: Double?
    public let averageHeartRate: Double?
    public let peakHeartRate: Double?

    public init(
        id: UUID,
        type: WorkoutType,
        startedAt: Date,
        durationMinutes: Double,
        distanceMeters: Double? = nil,
        averageHeartRate: Double? = nil,
        peakHeartRate: Double? = nil
    ) {
        self.id = id
        self.type = type
        self.startedAt = startedAt
        self.durationMinutes = durationMinutes
        self.distanceMeters = distanceMeters
        self.averageHeartRate = averageHeartRate
        self.peakHeartRate = peakHeartRate
    }
}
