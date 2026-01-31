//
//  WorkoutSplit.swift
//  Models
//
//  Created by Codex.
//

import Foundation

public struct WorkoutSplit: Codable, Hashable, Sendable, Identifiable {
    public let id: UUID
    public let index: Int
    public let distanceMeters: Double
    public let durationSeconds: TimeInterval
    public let paceSecondsPerKilometer: TimeInterval
    public let startDate: Date
    public let endDate: Date
    public let averageHeartRateBpm: Double?

    public init(
        id: UUID = UUID(),
        index: Int,
        distanceMeters: Double,
        durationSeconds: TimeInterval,
        paceSecondsPerKilometer: TimeInterval,
        startDate: Date,
        endDate: Date,
        averageHeartRateBpm: Double? = nil
    ) {
        self.id = id
        self.index = index
        self.distanceMeters = distanceMeters
        self.durationSeconds = durationSeconds
        self.paceSecondsPerKilometer = paceSecondsPerKilometer
        self.startDate = startDate
        self.endDate = endDate
        self.averageHeartRateBpm = averageHeartRateBpm
    }
}
