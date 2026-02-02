//
//  HealthStoreAdaptorProtocol.swift
//  MyHealth
//
//  Created by Codex.
//

import Foundation
import Models

public protocol HealthStoreAdaptorProtocol {
    var authorizationProvider: HealthAuthorizationProviding { get }
    func fetchWorkouts() async -> [Workout]
    func fetchWorkout(id: UUID) async throws -> Workout
    func fetchWorkoutRoute(id: UUID) async throws -> [WorkoutRoutePoint]
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
    func fetchNutritionSamples(type: NutritionType, limit: Int) async -> [NutritionSample]
    func fetchNutritionSamples(type: NutritionType, start: Date, end: Date) async -> [NutritionSample]
    func fetchNutritionTotal(type: NutritionType, start: Date, end: Date) async -> Double?
    func saveNutritionSample(_ sample: NutritionSample) async throws
    func deleteNutritionSample(id: UUID, type: NutritionType) async throws
    func nutritionChangesStream() -> AsyncStream<Void>
}
