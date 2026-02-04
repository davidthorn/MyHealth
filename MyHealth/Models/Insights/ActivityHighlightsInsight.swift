//
//  ActivityHighlightsInsight.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct ActivityHighlightsInsight: Hashable, Sendable {
    public let recentDays: [ActivityRingsDay]
    public let previousDays: [ActivityRingsDay]
    public let totalMove: Double
    public let totalExerciseMinutes: Double
    public let totalStandHours: Double
    public let activeDays: Int
    public let daysWithRingClosed: Int
    public let bestDayDate: Date?
    public let bestDayMove: Double
    public let worstDayDate: Date?
    public let worstDayMove: Double
    public let averageMove: Double
    public let averageExercise: Double
    public let averageStand: Double
    public let averageMoveGoal: Double
    public let averageExerciseGoal: Double
    public let averageStandGoal: Double

    public init(
        recentDays: [ActivityRingsDay],
        previousDays: [ActivityRingsDay],
        totalMove: Double,
        totalExerciseMinutes: Double,
        totalStandHours: Double,
        activeDays: Int,
        daysWithRingClosed: Int,
        bestDayDate: Date?,
        bestDayMove: Double,
        worstDayDate: Date?,
        worstDayMove: Double,
        averageMove: Double,
        averageExercise: Double,
        averageStand: Double,
        averageMoveGoal: Double,
        averageExerciseGoal: Double,
        averageStandGoal: Double
    ) {
        self.recentDays = recentDays
        self.previousDays = previousDays
        self.totalMove = totalMove
        self.totalExerciseMinutes = totalExerciseMinutes
        self.totalStandHours = totalStandHours
        self.activeDays = activeDays
        self.daysWithRingClosed = daysWithRingClosed
        self.bestDayDate = bestDayDate
        self.bestDayMove = bestDayMove
        self.worstDayDate = worstDayDate
        self.worstDayMove = worstDayMove
        self.averageMove = averageMove
        self.averageExercise = averageExercise
        self.averageStand = averageStand
        self.averageMoveGoal = averageMoveGoal
        self.averageExerciseGoal = averageExerciseGoal
        self.averageStandGoal = averageStandGoal
    }
}
