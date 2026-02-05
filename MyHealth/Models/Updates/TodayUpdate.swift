//
//  TodayUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct TodayUpdate: Sendable {
    public let title: String
    public let latestWorkout: TodayLatestWorkout?
    public let activityRingsDay: ActivityRingsDay?
    public let sleepDay: SleepDay?
    public let restingHeartRateSummary: RestingHeartRateSummary?
    public let heartRateVariabilitySummary: HeartRateVariabilitySummary?
    public let heartRateSummary: HeartRateSummary?
    public let stepsSummary: StepsSummary?
    public let caloriesSummary: CaloriesSummary?
    public let exerciseMinutesSummary: ExerciseMinutesSummary?
    public let standHoursSummary: StandHoursSummary?
    public let hydrationMilliliters: Double?

    public init(
        title: String,
        latestWorkout: TodayLatestWorkout?,
        activityRingsDay: ActivityRingsDay?,
        sleepDay: SleepDay?,
        restingHeartRateSummary: RestingHeartRateSummary?,
        heartRateVariabilitySummary: HeartRateVariabilitySummary?,
        heartRateSummary: HeartRateSummary?,
        stepsSummary: StepsSummary?,
        caloriesSummary: CaloriesSummary?,
        exerciseMinutesSummary: ExerciseMinutesSummary?,
        standHoursSummary: StandHoursSummary?,
        hydrationMilliliters: Double?
    ) {
        self.title = title
        self.latestWorkout = latestWorkout
        self.activityRingsDay = activityRingsDay
        self.sleepDay = sleepDay
        self.restingHeartRateSummary = restingHeartRateSummary
        self.heartRateVariabilitySummary = heartRateVariabilitySummary
        self.heartRateSummary = heartRateSummary
        self.stepsSummary = stepsSummary
        self.caloriesSummary = caloriesSummary
        self.exerciseMinutesSummary = exerciseMinutesSummary
        self.standHoursSummary = standHoursSummary
        self.hydrationMilliliters = hydrationMilliliters
    }
}
