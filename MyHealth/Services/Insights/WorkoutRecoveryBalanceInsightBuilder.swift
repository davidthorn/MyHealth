//
//  WorkoutRecoveryBalanceInsightBuilder.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import HealthKitAdaptor
import Models

public struct WorkoutRecoveryBalanceInsightBuilder {
    private let healthKitAdapter: HealthKitAdapterProtocol
    private let workouts: [Workout]
    private let includeHeartRate: Bool
    private let includeResting: Bool
    private let includeHrv: Bool

    public init(
        healthKitAdapter: HealthKitAdapterProtocol,
        workouts: [Workout],
        includeHeartRate: Bool,
        includeResting: Bool,
        includeHrv: Bool
    ) {
        self.healthKitAdapter = healthKitAdapter
        self.workouts = workouts
        self.includeHeartRate = includeHeartRate
        self.includeResting = includeResting
        self.includeHrv = includeHrv
    }

    public func build() async -> WorkoutRecoveryBalanceInsight? {
        guard includeResting || includeHrv else { return nil }

        let loadBuilder = WorkoutLoadTrendInsightBuilder(
            healthKitAdapter: healthKitAdapter,
            workouts: workouts,
            includeHeartRate: includeHeartRate
        )
        let loadInsight = await loadBuilder.build()
        guard let loadInsight else { return nil }

        let recoveryBuilder = RecoveryReadinessInsightBuilder(
            healthKitAdapter: healthKitAdapter,
            includeResting: includeResting,
            includeHrv: includeHrv,
            windowDays: 14
        )
        let recoveryInsight = await recoveryBuilder.build()
        guard let recoveryInsight else { return nil }

        let status = determineStatus(
            loadStatus: loadInsight.status,
            recoveryStatus: recoveryInsight.status
        )

        return WorkoutRecoveryBalanceInsight(
            windowStart: recoveryInsight.windowStart,
            windowEnd: recoveryInsight.windowEnd,
            currentWeekStart: loadInsight.currentWeekStart,
            currentWeekEnd: loadInsight.currentWeekEnd,
            loadMinutes: loadInsight.currentMinutes,
            loadScore: loadInsight.currentLoad,
            workoutCount: loadInsight.currentWorkoutCount,
            loadStatus: loadInsight.status,
            latestRestingBpm: recoveryInsight.latestRestingBpm,
            latestHrvMilliseconds: recoveryInsight.latestHrvMilliseconds,
            restingTrend: recoveryInsight.restingTrend,
            hrvTrend: recoveryInsight.hrvTrend,
            recoveryStatus: recoveryInsight.status,
            status: status
        )
    }

    private func determineStatus(
        loadStatus: WorkoutLoadTrendStatus,
        recoveryStatus: RecoveryReadinessStatus
    ) -> WorkoutRecoveryBalanceStatus {
        switch recoveryStatus {
        case .strained:
            return .overreaching
        case .ready:
            if loadStatus == .tapering {
                return .readyForMore
            }
            return .balanced
        case .steady:
            if loadStatus == .tapering {
                return .readyForMore
            }
            return .balanced
        case .unclear:
            return .unclear
        }
    }
}
