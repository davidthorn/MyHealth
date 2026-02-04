//
//  WorkoutRecoveryBalanceInsight.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public struct WorkoutRecoveryBalanceInsight: Hashable, Sendable {
    public let windowStart: Date
    public let windowEnd: Date
    public let currentWeekStart: Date
    public let currentWeekEnd: Date
    public let loadMinutes: Double?
    public let loadScore: Double?
    public let workoutCount: Int
    public let loadStatus: WorkoutLoadTrendStatus?
    public let latestRestingBpm: Double?
    public let latestHrvMilliseconds: Double?
    public let restingTrend: RecoveryReadinessTrend?
    public let hrvTrend: RecoveryReadinessTrend?
    public let recoveryStatus: RecoveryReadinessStatus?
    public let status: WorkoutRecoveryBalanceStatus

    public init(
        windowStart: Date,
        windowEnd: Date,
        currentWeekStart: Date,
        currentWeekEnd: Date,
        loadMinutes: Double?,
        loadScore: Double?,
        workoutCount: Int,
        loadStatus: WorkoutLoadTrendStatus?,
        latestRestingBpm: Double?,
        latestHrvMilliseconds: Double?,
        restingTrend: RecoveryReadinessTrend?,
        hrvTrend: RecoveryReadinessTrend?,
        recoveryStatus: RecoveryReadinessStatus?,
        status: WorkoutRecoveryBalanceStatus
    ) {
        self.windowStart = windowStart
        self.windowEnd = windowEnd
        self.currentWeekStart = currentWeekStart
        self.currentWeekEnd = currentWeekEnd
        self.loadMinutes = loadMinutes
        self.loadScore = loadScore
        self.workoutCount = workoutCount
        self.loadStatus = loadStatus
        self.latestRestingBpm = latestRestingBpm
        self.latestHrvMilliseconds = latestHrvMilliseconds
        self.restingTrend = restingTrend
        self.hrvTrend = hrvTrend
        self.recoveryStatus = recoveryStatus
        self.status = status
    }
}
