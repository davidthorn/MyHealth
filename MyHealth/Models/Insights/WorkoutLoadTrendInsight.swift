//
//  WorkoutLoadTrendInsight.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public struct WorkoutLoadTrendInsight: Hashable, Sendable {
    public let windowStart: Date
    public let windowEnd: Date
    public let currentWeekStart: Date
    public let currentWeekEnd: Date
    public let previousWeekStart: Date
    public let previousWeekEnd: Date
    public let currentLoad: Double?
    public let previousLoad: Double?
    public let delta: Double?
    public let status: WorkoutLoadTrendStatus
    public let currentWorkoutCount: Int
    public let previousWorkoutCount: Int
    public let currentMinutes: Double
    public let previousMinutes: Double

    public init(
        windowStart: Date,
        windowEnd: Date,
        currentWeekStart: Date,
        currentWeekEnd: Date,
        previousWeekStart: Date,
        previousWeekEnd: Date,
        currentLoad: Double?,
        previousLoad: Double?,
        delta: Double?,
        status: WorkoutLoadTrendStatus,
        currentWorkoutCount: Int,
        previousWorkoutCount: Int,
        currentMinutes: Double,
        previousMinutes: Double
    ) {
        self.windowStart = windowStart
        self.windowEnd = windowEnd
        self.currentWeekStart = currentWeekStart
        self.currentWeekEnd = currentWeekEnd
        self.previousWeekStart = previousWeekStart
        self.previousWeekEnd = previousWeekEnd
        self.currentLoad = currentLoad
        self.previousLoad = previousLoad
        self.delta = delta
        self.status = status
        self.currentWorkoutCount = currentWorkoutCount
        self.previousWorkoutCount = previousWorkoutCount
        self.currentMinutes = currentMinutes
        self.previousMinutes = previousMinutes
    }
}
