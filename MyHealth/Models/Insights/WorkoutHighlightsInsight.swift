//
//  WorkoutHighlightsInsight.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct WorkoutHighlightsInsight: Hashable, Sendable {
    public let windowStart: Date
    public let windowEnd: Date
    public let workoutCount: Int
    public let totalDurationMinutes: Double
    public let totalDistanceMeters: Double?
    public let averageHeartRate: Double?
    public let peakHeartRate: Double?
    public let mostIntenseWorkout: WorkoutInsightSummary?
    public let longestWorkout: WorkoutInsightSummary?
    public let recentWorkouts: [WorkoutInsightSummary]

    public init(
        windowStart: Date,
        windowEnd: Date,
        workoutCount: Int,
        totalDurationMinutes: Double,
        totalDistanceMeters: Double? = nil,
        averageHeartRate: Double? = nil,
        peakHeartRate: Double? = nil,
        mostIntenseWorkout: WorkoutInsightSummary? = nil,
        longestWorkout: WorkoutInsightSummary? = nil,
        recentWorkouts: [WorkoutInsightSummary]
    ) {
        self.windowStart = windowStart
        self.windowEnd = windowEnd
        self.workoutCount = workoutCount
        self.totalDurationMinutes = totalDurationMinutes
        self.totalDistanceMeters = totalDistanceMeters
        self.averageHeartRate = averageHeartRate
        self.peakHeartRate = peakHeartRate
        self.mostIntenseWorkout = mostIntenseWorkout
        self.longestWorkout = longestWorkout
        self.recentWorkouts = recentWorkouts
    }
}
