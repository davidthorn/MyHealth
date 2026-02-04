//
//  RecoveryReadinessInsight.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation

public struct RecoveryReadinessInsight: Hashable, Sendable {
    public let windowStart: Date
    public let windowEnd: Date
    public let latestRestingBpm: Double?
    public let latestHrvMilliseconds: Double?
    public let currentRestingAverage: Double?
    public let previousRestingAverage: Double?
    public let currentHrvAverage: Double?
    public let previousHrvAverage: Double?
    public let restingTrend: RecoveryReadinessTrend
    public let hrvTrend: RecoveryReadinessTrend
    public let status: RecoveryReadinessStatus

    public init(
        windowStart: Date,
        windowEnd: Date,
        latestRestingBpm: Double?,
        latestHrvMilliseconds: Double?,
        currentRestingAverage: Double?,
        previousRestingAverage: Double?,
        currentHrvAverage: Double?,
        previousHrvAverage: Double?,
        restingTrend: RecoveryReadinessTrend,
        hrvTrend: RecoveryReadinessTrend,
        status: RecoveryReadinessStatus
    ) {
        self.windowStart = windowStart
        self.windowEnd = windowEnd
        self.latestRestingBpm = latestRestingBpm
        self.latestHrvMilliseconds = latestHrvMilliseconds
        self.currentRestingAverage = currentRestingAverage
        self.previousRestingAverage = previousRestingAverage
        self.currentHrvAverage = currentHrvAverage
        self.previousHrvAverage = previousHrvAverage
        self.restingTrend = restingTrend
        self.hrvTrend = hrvTrend
        self.status = status
    }
}
