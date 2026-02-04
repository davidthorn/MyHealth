//
//  SleepTrainingBalanceInsight.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct SleepTrainingBalanceInsight: Hashable, Sendable {
    public let windowStart: Date
    public let windowEnd: Date
    public let currentWeekStart: Date
    public let currentWeekEnd: Date
    public let previousWeekStart: Date
    public let previousWeekEnd: Date
    public let currentSleepHours: Double?
    public let previousSleepHours: Double?
    public let sleepDeltaHours: Double?
    public let currentLoadMinutes: Double?
    public let previousLoadMinutes: Double?
    public let loadDeltaMinutes: Double?
    public let workoutCount: Int
    public let status: SleepTrainingBalanceStatus

    public init(
        windowStart: Date,
        windowEnd: Date,
        currentWeekStart: Date,
        currentWeekEnd: Date,
        previousWeekStart: Date,
        previousWeekEnd: Date,
        currentSleepHours: Double?,
        previousSleepHours: Double?,
        sleepDeltaHours: Double?,
        currentLoadMinutes: Double?,
        previousLoadMinutes: Double?,
        loadDeltaMinutes: Double?,
        workoutCount: Int,
        status: SleepTrainingBalanceStatus
    ) {
        self.windowStart = windowStart
        self.windowEnd = windowEnd
        self.currentWeekStart = currentWeekStart
        self.currentWeekEnd = currentWeekEnd
        self.previousWeekStart = previousWeekStart
        self.previousWeekEnd = previousWeekEnd
        self.currentSleepHours = currentSleepHours
        self.previousSleepHours = previousSleepHours
        self.sleepDeltaHours = sleepDeltaHours
        self.currentLoadMinutes = currentLoadMinutes
        self.previousLoadMinutes = previousLoadMinutes
        self.loadDeltaMinutes = loadDeltaMinutes
        self.workoutCount = workoutCount
        self.status = status
    }
}
