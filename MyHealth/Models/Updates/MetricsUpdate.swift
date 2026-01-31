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
    public let restingHeartRateSummary: RestingHeartRateSummary?
    public let stepsSummary: StepsSummary?
    public let flightsSummary: FlightsSummary?
    public let standHoursSummary: StandHoursSummary?
    public let caloriesSummary: CaloriesSummary?
    public let sleepSummary: SleepSummary?
    public let activityRingsSummary: ActivityRingsSummary?

    public init(
        title: String,
        heartRateSummary: HeartRateSummary?,
        restingHeartRateSummary: RestingHeartRateSummary?,
        stepsSummary: StepsSummary?,
        flightsSummary: FlightsSummary?,
        standHoursSummary: StandHoursSummary?,
        caloriesSummary: CaloriesSummary?,
        sleepSummary: SleepSummary?,
        activityRingsSummary: ActivityRingsSummary?
    ) {
        self.title = title
        self.heartRateSummary = heartRateSummary
        self.restingHeartRateSummary = restingHeartRateSummary
        self.stepsSummary = stepsSummary
        self.flightsSummary = flightsSummary
        self.standHoursSummary = standHoursSummary
        self.caloriesSummary = caloriesSummary
        self.sleepSummary = sleepSummary
        self.activityRingsSummary = activityRingsSummary
    }
}
