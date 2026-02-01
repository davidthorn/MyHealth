//
//  HealthAuthorizationProviding.swift
//  HealthKitAdaptor
//
//  Created by Codex.
//

import HealthKit

public protocol HealthAuthorizationProviding {
    func requestAuthorization(readTypes: Set<HKObjectType>) async -> Bool
    func requestAllAuthorization() async -> Bool
    func requestWorkoutAuthorization() async -> Bool
    func requestHeartRateAuthorization() async -> Bool
    func requestStepsAuthorization() async -> Bool
    func requestFlightsAuthorization() async -> Bool
    func requestStandHoursAuthorization() async -> Bool
    func requestActiveEnergyAuthorization() async -> Bool
    func requestSleepAnalysisAuthorization() async -> Bool
    func requestActivitySummaryAuthorization() async -> Bool
    func requestRestingHeartRateAuthorization() async -> Bool
}
