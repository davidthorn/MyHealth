//
//  MetricsUpdate.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public struct MetricsUpdate: Sendable {
    public let title: String
    public let heartRateSummary: HeartRateSummary?
    public let cardioFitnessSummary: CardioFitnessSummary?
    public let bloodOxygenSummary: BloodOxygenSummary?
    public let heartRateVariabilitySummary: HeartRateVariabilitySummary?
    public let restingHeartRateSummary: RestingHeartRateSummary?
    public let stepsSummary: StepsSummary?
    public let flightsSummary: FlightsSummary?
    public let standHoursSummary: StandHoursSummary?
    public let exerciseMinutesSummary: ExerciseMinutesSummary?
    public let caloriesSummary: CaloriesSummary?
    public let sleepSummary: SleepSummary?
    public let activityRingsSummary: ActivityRingsSummary?
    public let nutritionSummary: NutritionWindowSummary?

    public init(
        title: String,
        heartRateSummary: HeartRateSummary?,
        cardioFitnessSummary: CardioFitnessSummary?,
        bloodOxygenSummary: BloodOxygenSummary?,
        heartRateVariabilitySummary: HeartRateVariabilitySummary?,
        restingHeartRateSummary: RestingHeartRateSummary?,
        stepsSummary: StepsSummary?,
        flightsSummary: FlightsSummary?,
        standHoursSummary: StandHoursSummary?,
        exerciseMinutesSummary: ExerciseMinutesSummary?,
        caloriesSummary: CaloriesSummary?,
        sleepSummary: SleepSummary?,
        activityRingsSummary: ActivityRingsSummary?,
        nutritionSummary: NutritionWindowSummary?
    ) {
        self.title = title
        self.heartRateSummary = heartRateSummary
        self.cardioFitnessSummary = cardioFitnessSummary
        self.bloodOxygenSummary = bloodOxygenSummary
        self.heartRateVariabilitySummary = heartRateVariabilitySummary
        self.restingHeartRateSummary = restingHeartRateSummary
        self.stepsSummary = stepsSummary
        self.flightsSummary = flightsSummary
        self.standHoursSummary = standHoursSummary
        self.exerciseMinutesSummary = exerciseMinutesSummary
        self.caloriesSummary = caloriesSummary
        self.sleepSummary = sleepSummary
        self.activityRingsSummary = activityRingsSummary
        self.nutritionSummary = nutritionSummary
    }
}
