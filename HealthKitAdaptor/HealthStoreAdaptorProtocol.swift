//
//  HealthStoreAdaptorProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol HealthStoreAdaptorProtocol {
    func requestWorkoutAuthorization() async -> Bool
    func requestHeartRateAuthorization() async -> Bool
    func requestStepsAuthorization() async -> Bool
    func requestFlightsAuthorization() async -> Bool
    func requestStandHoursAuthorization() async -> Bool
    func requestActiveEnergyAuthorization() async -> Bool
    func requestSleepAnalysisAuthorization() async -> Bool
    func requestActivitySummaryAuthorization() async -> Bool
    func requestRestingHeartRateAuthorization() async -> Bool
    func fetchWorkouts() async -> [Workout]
    func fetchWorkout(id: UUID) async throws -> Workout
    func deleteWorkout(id: UUID) async throws
    func fetchHeartRateReadings(limit: Int) async -> [HeartRateReading]
    func fetchHeartRateReading(id: UUID) async throws -> HeartRateReading
    func fetchHeartRateReadings(start: Date, end: Date) async -> [HeartRateReading]
    func fetchStepCounts(days: Int) async -> [StepsDay]
    func fetchFlightCounts(days: Int) async -> [FlightsDay]
    func fetchStandHourCounts(days: Int) async -> [StandHourDay]
    func fetchActiveEnergy(days: Int) async -> [CaloriesDay]
    func fetchRestingHeartRateDays(days: Int) async -> [RestingHeartRateDay]
    func fetchRestingHeartRateReadings(on date: Date) async -> [RestingHeartRateReading]
    func fetchActivitySummaries(days: Int) async -> [ActivityRingsDay]
    func fetchActivitySummaryDay(date: Date) async -> ActivityRingsDay
    func fetchSleepAnalysis(days: Int) async -> [SleepDay]
    func fetchSleepAnalysisDay(date: Date) async -> SleepDay
}
