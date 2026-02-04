//
//  WorkoutIntensityDistributionInsight.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public struct WorkoutIntensityDistributionInsight: Hashable, Sendable {
    public let windowStart: Date
    public let windowEnd: Date
    public let lowMinutes: Double
    public let moderateMinutes: Double
    public let highMinutes: Double
    public let workoutCount: Int
    public let status: WorkoutIntensityBalanceStatus

    public init(
        windowStart: Date,
        windowEnd: Date,
        lowMinutes: Double,
        moderateMinutes: Double,
        highMinutes: Double,
        workoutCount: Int,
        status: WorkoutIntensityBalanceStatus
    ) {
        self.windowStart = windowStart
        self.windowEnd = windowEnd
        self.lowMinutes = lowMinutes
        self.moderateMinutes = moderateMinutes
        self.highMinutes = highMinutes
        self.workoutCount = workoutCount
        self.status = status
    }
}
