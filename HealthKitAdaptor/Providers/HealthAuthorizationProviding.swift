//
//  HealthAuthorizationProviding.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import HealthKit
import Models

public protocol HealthAuthorizationProviding: Sendable {
    func requestAuthorization(readTypes: Set<HKObjectType>) async -> Bool
    func requestAllAuthorization() async -> Bool
    func requestWorkoutAuthorization() async -> Bool
    func requestCreateWorkoutAuthorization() async -> Bool
    func requestHeartRateAuthorization() async -> Bool
    func requestBloodOxygenAuthorization() async -> Bool
    func requestHeartRateVariabilityAuthorization() async -> Bool
    func requestStepsAuthorization() async -> Bool
    func requestFlightsAuthorization() async -> Bool
    func requestStandHoursAuthorization() async -> Bool
    func requestExerciseMinutesAuthorization() async -> Bool
    func requestActiveEnergyAuthorization() async -> Bool
    func requestSleepAnalysisAuthorization() async -> Bool
    func requestActivitySummaryAuthorization() async -> Bool
    func requestRestingHeartRateAuthorization() async -> Bool
    func requestNutritionReadAuthorization(type: NutritionType) async -> Bool
    func requestNutritionWriteAuthorization(type: NutritionType) async -> Bool
}
